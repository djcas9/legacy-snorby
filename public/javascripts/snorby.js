// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function swap_in() {
	Element.addClassName('more', 'loading');
}

function swap_out() {
	Element.removeClassName('more', 'loading');
}