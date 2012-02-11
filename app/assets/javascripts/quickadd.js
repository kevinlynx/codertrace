jQuery(document).ready(function() {
    $('#quickadd').hide();
});

function popup_quickadd() {
    var target = $(get_target(arguments.callee.caller.arguments[0]));
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

function switch_quickadd() {
    var e = $('#quickadd');
    if (e.is(':visible')) 
        hide_quickadd();
    else
        popup_quickadd();
}

function get_target(e) {
    var targ;
    if (!e) var e = window.event;
    if (e.target) targ = e.target;
    else if (e.srcElement) targ = e.srcElement;
    if (targ.nodeType == 3) // defeat Safari bug
        targ = targ.parentNode;
    return targ;
}

