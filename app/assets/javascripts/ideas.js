$(document).ready(function(){
  fetchIdeas();
  createIdeaButton();
  $('#ideas').on('click', 'input', function(event){
    deleteIdea(event.target.id);
  });
  $('#ideas').on('click', 'button', function(event){
    updateIdea(event.target)
  })
});

var reRenderIdea = function(ideaHTML) {
  var id = this.url.split('/').splice(4, 5).join('')
  $('#idea-' + id).replaceWith(ideaHTML)
}

var processUpdate = function(id, updateData) {
  $.ajax({
    url: '/api/v1/ideas/' + id,
    method: 'put',
    data: updateData
  }).then(createIdeaHTML)
  .then(reRenderIdea)
  .fail(handleError);
};

var qualityUpdate = function(type, id, currentQuality) {
  var newQuality;
  
  if (type === 'up') {
    if (currentQuality === 'swill') {
      newQuality = 'plausible'
    } else if (currentQuality === 'plausible') {
      newQuality = 'genius'
    }
  } else {
    if (currentQuality === 'genius') {
      newQuality = 'plausible'
    } else if (currentQuality === 'plausible') {
      newQuality = 'swill'
    }
  }

  processUpdate(id, { quality: newQuality });
};

var updateIdea = function(targetData) {
  var idData = targetData.id.split('-');
  var buttonType = idData[0];
  var id = idData[1];
  var currentQuality = $('#idea-' + id).children('.quality').text();
  if (buttonType !== 'submit') {
    qualityUpdate(buttonType, id, currentQuality);
  }
};

var removeIdeaHTML = function(id) {
  $('#idea-' + id).remove();
};

var deleteIdea = function(id) {
  $.ajax({
    url: '/api/v1/ideas/' + id,
    type: 'delete'
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

var createThumbsButton = function(type, idea) {
  var disabledStatus;
  var id;

  if ((idea.quality === 'genius' && type === 'Thumbs Up') || (idea.quality === 'swill' && type === 'Thumbs Down')) {
    disabledStatus = "disabled='true'"
  } else {
    disabledStatus = ''
  }

  if (type === 'Thumbs Up') {
    id = 'up-' + idea.id
  } else {
    id = 'down-' + idea.id
  }

  return (
    "<button type='button' class='btn btn-success btn-xs' id='"
    + id
    + "'"
    + disabledStatus
    + "'>"
    + type
    +"</button>"
  );
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
    + "<h6 class='quality'>"
    + idea.quality
    + "</h6>"
    + "<input class='btn btn-danger' id='"
    + idea.id
    + "' type='button' name='delete' value='Delete'>"
    + createThumbsButton('Thumbs Down', idea)
    + createThumbsButton('Thumbs Up', idea)
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
