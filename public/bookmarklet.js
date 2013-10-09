// alert(encodeURIComponent(location.href))
(function() {
    var go = function(){
      var $ = window.$.noConflict();
      $.post('http://localhost:3000/posts');
    }

    var script = document.createElement('script');
    script.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js');
    script.onreadystatechange = go;
    script.onload = go;
    document.body.appendChild(script);
})()