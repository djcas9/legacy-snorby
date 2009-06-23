// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function showlayer(layer){
var myLayer = document.getElementById(layer);
if(myLayer.style.display=="none" || myLayer.style.display==""){
myLayer.style.display="block";
} else { 
myLayer.style.display="none";
}
}