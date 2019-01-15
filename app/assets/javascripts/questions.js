$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });
});

$(document).on('ajax:success', 'a.vote_question', function (e) {
    var votes = e.detail[0];
    var questionId = $(this).data('votableId');

    $('.question-votes-' + questionId).html('<p>Рейтинг: ' + votes + '</p>');
});