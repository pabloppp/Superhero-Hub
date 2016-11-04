

/*window.addEventListener('load', function(){
  var hname = document.getElementById('hero-name');
  console.log(hname);

  names = hname.innerHTML.split(',').map(function(i){return i.trim()});
  names = names.filter(function(i){ return i !== ""});
  firstName = '<b>'+names[0]+'</b>';
  names.splice(0, 1);
  console.log(names);
  hname.innerHTML = firstName+" ( "+names.join(', ')+" )";


})*/

var firstUpdate = false;
var showLikes = function(e){
  if(!firstUpdate) updateLikes();
  var tgt = e.target;
  if(tgt.nodeName == 'IMG') tgt = tgt.parentNode;
  if(tgt.showTimeout) clearTimeout(tgt.showTimeout);
  tgt.classList.add('show-likes');
  tgt.showTimeout = setTimeout(function(){
    tgt.classList.remove('show-likes');
  }, 500);
}

var nodeIndexOf = function(arr, v){
  for(var i=0;i<arr.length;i++){
    if(arr[i] === v) return i;
  }
  return -1;
}

updateLikes = function(){
  firstUpdate = true;
  if(!current_user_likes) return;
  var hearts = document.getElementById('likes-hub').children;
  for(var i=0;i<hearts.length;i++){
    hearts[i].classList.remove('selecting')
    if(current_user_likes < i+1){
      hearts[i].classList.remove('fa-heart')
      hearts[i].classList.add('fa-heart-o')
      hearts[i].classList.remove('selected')
    }
    else{
      hearts[i].classList.remove('fa-heart-o')
      hearts[i].classList.add('fa-heart')
      hearts[i].classList.add('selected')
    }
  }
}

var showPossibleLikes = function(e){
  likesUpdating = true;
  var hearts = e.target.parentNode.children;
  var sel = nodeIndexOf(hearts, e.target);
  for(var i=0;i<hearts.length;i++){
    if(sel < i){
      if(hearts[i].classList.contains('selected')) hearts[i].classList.add('selecting')
      else{
        hearts[i].classList.remove('fa-heart')
        hearts[i].classList.add('fa-heart-o')
        hearts[i].classList.remove('selecting')
      }
    }
    else{
      if(hearts[i].classList.contains('selected')) hearts[i].classList.remove('selecting')
      else{
        hearts[i].classList.add('fa-heart')
        hearts[i].classList.remove('fa-heart-o')
        hearts[i].classList.add('selecting')
      }
    }
  }
}

var resetLikes = function(e){
  var hearts = e.target.children;
  likesUpdating = false;
  for(var i=0;i<hearts.length;i++){
    if(hearts[i].classList.contains('selected')) hearts[i].classList.remove('selecting')
    else{
      hearts[i].classList.remove('fa-heart')
      hearts[i].classList.add('fa-heart-o')
      hearts[i].classList.remove('selecting')
    }
  }
}

var dolike = function(id, value){
  var form = $('#like-form');
  $.ajax({
    type: "POST",
    url: '/superheroes/'+id+'/likes',
    data: 'like[value]='+value, // serializes the form's elements.
    success: function(data){
      //alert(data); // show response from the php script.
      var oldV = current_user_likes;
      current_user_likes = value;
      var likesAvg = Number(document.getElementById('likesAvg').innerHTML)
      var sum = totalLikes*likesAvg
      sum = sum-oldV+current_user_likes;
      if(oldV === 0) totalLikes += 1;
      document.getElementById('likesAvg').innerHTML = sum/totalLikes;
      updateLikes();
    }
  });
}
