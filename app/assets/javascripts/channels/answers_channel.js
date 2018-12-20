App.cable.subscriptions.create('AnswersChannel', {

    connected: function() {
        var questionId = $('.question').data('id');

        if (questionId) {
            this.perform('subscribed', { id: questionId })
        }
    },

    received: function(data) {
        var current_user = gon.current_user_id;
        answer_user_id = JSON.parse(data["answer_user_id"]);

        if ( answer_user_id !== current_user ) {
            $('.answers').append(JST["templates/answer"]({ data: data }));
        }
    }
});