// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require i18n
//= require i18n/translations
//= require quickadd

jQuery(function($) {
    var e = $('#refresh-link')
    if (e.length != 0) { /* maybe it's not the user index page */
        e.bind('ajax:beforeSend', disable_refresh_link);
        request_latest_posts();
    }
})

function disable_link(e) {
    e.preventDefault();
    return false;
}

function disable_refresh_link() {
    var e = $('#refresh-link');
    e.text(I18n.t('frontend.wait_refresh'));
    e.bind('click', disable_link);
}

function enable_refresh_link() {
    var e = $('#refresh-link');
    e.text(I18n.t('frontend.refresh'));
    e.unbind('click', disable_link);
}

function refresh_post_failed() {
    enable_refresh_link();
    $('#refresh-link').text(I18n.t('frontend.timeout'));
}

function refresh_progress(url, times) {
    times ++;
    $.post(url, function(data, stat, xhr) {
                    if (data["progress"] != "-1") {
                        if (times >= 30) {
                            refresh_post_failed()
                        } else {
                            setTimeout(function () { refresh_progress(url, times); }, 1000);
                        }
                    } else {
                        $('#post-list').html(data["posts"]);
                        $('#posts-update-time').html(data["update_at"]);
                        enable_refresh_link();
                    }
                });
}

function start_refresh_progress(url) {
    var times = 0;
    setTimeout(function () { refresh_progress(url, times); }, 1000);
}

function request_latest_posts() {
    disable_refresh_link();
    $.post($('#refresh-link').attr('href'));
}

function refresh_entry(url, times) {
    times ++;
    $.get(url, function(data, stat, xhr) {
                    if (data["complete"] == "failed") { /* failed */
                        $('#entry-tip-'+data["id"]).html(I18n.t("frontend.failed"));
                        $('#entry-result-'+data["id"]).html(data["err_msg"]);
                    } else if (data["complete"] == "wait") { /* processing */
                        if (times >= 30) {
                            $('#entry-tip-'+data["id"]).html(I18n.t("frontend.timeout"))
                        } else {
                            setTimeout(function() { refresh_entry(url, times); }, 1000);
                        }
                    } else {
                        $('#entry-'+data["id"]).html(data["entry"])
                        /* after added an entry, it should refresh the posts */
                        request_latest_posts();
                    }
            });
}

function start_refresh_entry(url) {
    var times = 0;
    setTimeout(function() { refresh_entry(url ,times); }, 1000);
}

