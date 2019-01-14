App.cable.subscriptions.create('AnswersChannel', {

    connected: function() {
        var question_id = $('.question').data('id');

        if (question_id) {
            this.perform('follow_answers', { id: question_id });
        } else {
            this.perform('unfollow');
        }
    },

    received: function(data) {
        var current_user = gon.current_user_id;
        answer_user_id = data["answer_user_id"];

        if ( answer_user_id !== current_user ) {
            $('.answers').append(JST["templates/answer"]({ data: data }));
        }
    }
});