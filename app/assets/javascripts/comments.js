$(document).on('turbolinks:load', function(){
    $('.comments').on('click', '.add_comment_link', function(e) {
        e.preventDefault();
        $(this).hide();
        resource_id = $(this).data('resourceId');
        $('form#' + resource_id).show();
    });
});