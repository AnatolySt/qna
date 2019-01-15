App.cable.subscriptions.create('CommentsChannel', {

    connected: function() {
        var question_id = $('.question').data('id');

        if (question_id) {
            this.perform('follow_comments', { id: question_id });
        } else {
            this.perform('unfollow');
        }
    },

    received: function(data) {

        var current_user = gon.current_user_id;
        comment_user_id = data.user_id;

        if ( comment_user_id != current_user ) {
            var comments_list = '#comments-' + data['commentable_type'].toLowerCase() + '-' + data['commentable_id'];
            $(comments_list).append(JST["templates/comment"]({ comment: data }));
        }
    }
});