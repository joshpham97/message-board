function getRecentPosts() {
    $.ajax({
        url: 'posts',
        type: 'GET',
        success: function(response) {
            displayPosts(JSON.parse(response));
        },
        error: function(e) {
            alert(e.responseText);
        }
    })
}

function displayPosts(posts) {
    if(posts.length > 0) {
        $("#posts").text("");

        $.each(posts, function (key, value) {
            // $.get("html/post.html?", { post: value }, function(data) {
            //     $("#posts").append(data);
            // });

            let post =
                '<div class="card mb-2">' +
                    '<div class="card-header">' +
                        '<div class="float-left text-muted">' +
                            '<span>' + value.username + '</span>' +
                            '<small><i class="far fa-clock pr-1"></i>Date</small>' +
                        '</div>' +
                        '<div class="float-right">' +
                            '<a href="/AttachmentServlet"><i class="fas fa-paperclip mr-2" title="Download attachment"></i></a>' +
                            '<a href="/AttachmentServlet"><i class="fas fa-edit mr-2"></i></a>' +
                            '<a href="/AttachmentServlet"><i class="fas fa-trash mr-2"></i></a>' +
                        '</div>' +
                    '</div>' +
                    '<div>' +
                        '<div class="card-body ">' +
                            '<div>' + value.message + '</div>' +
                            '<div class="float-right">' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

            $("#posts").append(post);
        });
    }
    else
        $("posts").text("No posts to display")
}

$(document).ready(function() {
    getRecentPosts();
});