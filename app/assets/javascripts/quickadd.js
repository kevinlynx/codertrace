jQuery(document).ready(function() {
    $('#quickadd').hide();
});

function popup_quickadd(e) {
    var target = $(e)
    var add = $('#quickadd');
    var pos = target.position();
    var height = target.outerHeight();
    add.css('left', pos.left + 'px');
    add.css('top', pos.top + height + 'px');
    add.show(300);
}

function hide_quickadd() {
    $('#quickadd').hide(300);
}

function switch_quickadd(target) {
    var e = $('#quickadd');
    if (e.is(':visible')) 
        hide_quickadd();
    else
        popup_quickadd(target);
}

