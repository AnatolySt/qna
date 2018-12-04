$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        answer_id = $(this).data('answerId');
        $('form#edit-answer-' + answer_id).show();
    });
});

var ready = function() {
    $('a.vote_answer').bind('ajax:success', function (e) {
        var votes = e.detail[0];
        var answerId = $(this).data('answerId');

        $('.answer-votes-' + answerId).html('<p>Рейтинг: ' + votes + '</p>');
    })
};

$(document).ready(ready);
$(document).on('turbolinks:load',ready);