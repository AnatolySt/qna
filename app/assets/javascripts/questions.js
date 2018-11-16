$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });
});