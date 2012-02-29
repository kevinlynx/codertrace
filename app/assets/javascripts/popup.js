function show_popup(pannel_id, target_id) {
    var target = $(target_id);
    var pannel = $(pannel_id);
    var pos = target.position();
    var height = target.outerHeight();
    pannel.css('left', pos.left + 'px');
    pannel.css('top', pos.top + height + 'px');
    pannel.show();
    pannel.mouseleave(function() { hide_popup(pannel_id); });
}

function hide_popup(pannel_id) {
    $(pannel_id).hide();
}

