$(document).ready(function(){
  fetchIdeas();
  createIdeaButton();
  $('#ideas').on('click', 'input', function(event){
    deleteIdea(event.target.id);
  });
});

var removeIdeaHTML = function(id) {
  $('#idea-' + id).remove();
};

var deleteIdea = function(id) {
  $.ajax({
    url: '/api/v1/ideas/' + id,
    type: 'delete',
    data: id
  }).then(removeIdeaHTML(id))
  .fail(handleError);
};

var createIdeaButton = function(){
  $('#create-idea').on('click', createIdea);
};

var clearInputs = function(){
  $('#idea-title').val('');
  $('#idea-body').val('');
}

var createIdea = function(){
  var ideaParams = {
    title: $('#idea-title').val(),
    body: $('#idea-body').val()
  };
  $.ajax({
    url: '/api/v1/ideas',
    type: 'post',
    data: ideaParams
  }).then(createIdeaHTML)
  .then(renderIdea)
  .then(clearInputs)
  .fail(handleError);
};

var renderIdea = function(ideaData) {
  $('#ideas').prepend(ideaData);
}

var handleError = function(error) { console.log(error) };

var limit100Words = function(text) {
  return text.split(' ').splice(0, 100).join(' ');
};

var createIdeaHTML = function(idea) {
  return(
    "<div class='idea well' id='idea-"
    + idea.id
    + "'>"
    + "<h3>"
    + idea.title
    + "</h3>"
    + "<p>"
    + limit100Words(idea.body)
    + "</p>"
    + "<h6>"
    + idea.quality
    + "</h6>"
    + "<input class='btn btn-danger' id='"
    + idea.id
    + "' type='button' name='delete' value='Delete'>"
    + "</div>"
  );
};

var collectIdeas = function(ideaData) {
  return ideaData.map(createIdeaHTML);
};

var renderIdeas = function(ideaData) {
  $('#ideas').html(ideaData);
};

var fetchIdeas = function(){
  $.ajax({
    url: '/api/v1/ideas'
  }).then(collectIdeas)
  .then(renderIdeas)
  .fail(handleError);
};
