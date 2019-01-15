$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        answer_id = $(this).data('answerId');
        $('form#edit-answer-' + answer_id).show();
    });
});

$(document).on('ajax:success', 'a.vote_answer', function (e) {
    var votes = e.detail[0];
    var answerId = $(this).data('votableId');

    $('.answer-votes-' + answerId).html('<p>Рейтинг: ' + votes + '</p>');
});