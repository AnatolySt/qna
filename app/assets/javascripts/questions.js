$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });
});


var ready = function() {
    $('a.vote_question').bind('ajax:success', function (e) {
        var votes = e.detail[0];

        $('.question-votes').html('<p>Рейтинг: ' + votes + '</p>');
    })
};

$(document).ready(ready);
$(document).on('turbolinks:load',ready);