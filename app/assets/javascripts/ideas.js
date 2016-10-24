$(document).ready(() => {
  fetchIdeas();
  createIdeaButton();
  watchForDelete();
  watchForUpdate();
  watchForNew();
});

const watchForNew = () => {
  $('.ideas').bind('DOMNodeInserted', searchBar);
};

const watchForUpdate = () => {
  $('#ideas').on('click', 'button', (event) => {
    updateIdea(event.target);
  });
};

const watchForDelete = () => {
  $('#ideas').on('click', 'input', (event) => {
    deleteIdea(event.target.id);
  });
};

const searchBar = () => {
  const $ideas = $('.idea');

  $('#search-box').on('keyup', function() {
    const currentEntry = this.value;

    $ideas.each((index, idea) => {
      let $idea = $(idea);
      if ($idea.data('all').toLowerCase().indexOf(currentEntry.toLowerCase()) !== -1){
        $idea.show();
      } else {
        $idea.hide();
      }
    });
  });
};

const searchBarPresent = () => {
  const $box = $('#idea-search-box');
  $('#ideas').children().length ? $box.show() : $box.hide();
};

const reRenderIdea = function(ideaHTML) {
  const id = this.url.split('/').splice(4, 5).join('');
  $('#idea-' + id).replaceWith(ideaHTML);
  canUpdateIdeaTitle();
  canUpdateIdeaBody();
  searchBar();
};

const processUpdate = (id, updateData) => {
  $.ajax({
    url: '/api/v1/ideas/' + id,
    method: 'put',
    data: updateData
  }).then(createIdeaHTML)
  .then(reRenderIdea)
  .fail(handleError);
};

const qualityUpdate = (type, id, currentQuality) => {
  let newQuality;

  if (type === 'up') {
    if (currentQuality === 'swill') {
      newQuality = 'plausible';
    } else if (currentQuality === 'plausible') {
      newQuality = 'genius';
    }
  } else {
    if (currentQuality === 'genius') {
      newQuality = 'plausible';
    } else if (currentQuality === 'plausible') {
      newQuality = 'swill';
    }
  }

  processUpdate(id, { quality: newQuality });
};

const updateIdea = (targetData) => {
  const idData = targetData.id.split('-');
  const buttonType = idData[0];
  const id = idData[1];
  const currentQuality = $('#idea-' + id).find('.quality').text();
  qualityUpdate(buttonType, id, currentQuality);
};

const removeIdeaHTML = (id) => {
  $('#idea-' + id).remove();
};

const deleteIdea = (id) => {
  $.ajax({
    url: '/api/v1/ideas/' + id,
    type: 'delete'
  }).then(removeIdeaHTML(id))
  .fail(handleError);

  searchBarPresent();
};

const createIdeaButton = () => {
  $('#create-idea').on('click', createIdea);
};

const clearInputs = () => {
  $('#idea-title').val('');
  $('#idea-body').val('');
};

const createIdea = () => {
  const ideaParams = {
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

const renderIdea = (ideaData) => {
  $('#ideas').prepend(ideaData);
  ensureUpdateAndSearch();
};

const ensureUpdateAndSearch = () => {
  canUpdateIdeaTitle();
  canUpdateIdeaBody();
  searchBarPresent();
  searchBar();
};

const handleError = (error) => { console.log(error); };

const limit100Chars = (text) => {
  const words = text.split(' ');
  let newString = "";
  let counter = 0;
  words.forEach(function(word){
    const wordSize = word.length;
    if (counter + wordSize <= 100) {
      counter += wordSize;
      newString = newString + word + " ";
    }
  });
  return newString.trim();
};

const createThumbsButton = (type, idea) => {
  let disabledStatus;
  let id;

  if ((idea.quality === 'genius' && type === 'Thumbs Up') || (idea.quality === 'swill' && type === 'Thumbs Down')) {
    disabledStatus = "disabled='true'";
  } else {
    disabledStatus = '';
  }

  if (type === 'Thumbs Up') {
    id = 'up-' + idea.id;
  } else {
    id = 'down-' + idea.id;
  }

  return (
    "<button type='button' class='btn btn-success btn-xs' id='" +
    id +
    "'" +
    disabledStatus +
    "'>" +
    type +
    "</button>"
  );
};

const createIdeaHTML = (idea) => {
  return(
    "<div class='idea well' id='idea-" +
    idea.id +
    "' data-id='" +
    idea.id +
    "' data-all='" +
    idea.title + " " + limit100Chars(idea.body) +
    "'>" +
    "<h3 contenteditable='true' id='title'>" +
    idea.title +
    "</h3>" +
    "<p contenteditable='true' id='body'>" +
    limit100Chars(idea.body) +
    "</p>" +
    "<h6 class='quality'>" +
    idea.quality +
    "</h6>" +
    "<input class='btn btn-danger btn-xs' id='" +
    idea.id +
    "' type='button' name='delete' value='Delete'>" +
    createThumbsButton('Thumbs Down', idea) +
    createThumbsButton('Thumbs Up', idea) +
    "</div>"
  );
};

const collectIdeas = (ideaData) => {
  return ideaData.map(createIdeaHTML);
};

const canUpdateIdeaTitle = () => {
  $('#title').on('focus', function(event) {
    $(event.target).on('keydown', function(e) {
      if (e.which === 13) {
        e.preventDefault();
        this.blur();
      }
    });

    $(event.target).on('blur', () => {
      const id = event.target.parentElement.id.split('-')[1];
      const titleUpdateData = event.target.textContent;
      $.ajax({
        url: '/api/v1/ideas/' + id,
        type: 'put',
        data: { title: titleUpdateData }
      }).fail(handleError);
    });

  });
};

const canUpdateIdeaBody = () => {
  $('#body').on('focus', function(event) {
    $(event.target).on('keydown', function(e) {
      if (e.which === 13) {
        e.preventDefault();
        this.blur();
      }
    });

    $(event.target).on('blur', () => {
      const id = event.target.parentElement.id.split('-')[1];
      const bodyUpdateData = event.target.textContent;
      $.ajax({
        url: '/api/v1/ideas/' + id,
        type: 'put',
        data: { body: bodyUpdateData }
      }).fail(handleError);
    });
  });
};

const renderIdeas = (ideaData) => {
  $('#ideas').html(ideaData);
  ensureUpdateAndSearch();
};

const fetchIdeas = () => {
  $.ajax({
    url: '/api/v1/ideas'
  }).then(collectIdeas)
  .then(renderIdeas)
  .fail(handleError);
};
