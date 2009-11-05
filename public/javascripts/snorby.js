// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
    var currentPage = 2

    // Hide Loading
    $('#loading').hide()

    if (!jQuery.browser.msie) {
        $('#snorby_logo').hover(function() {
            $(this).stop().animate({
                opacity: '0.5'
            })
        },
        function() {
            $(this).stop().animate({
                opacity: '1'
            })
        });
    };

    //Scroll
    $('#scroll_to_comment').click(function() {
        $.scrollTo($('#comment_form'), 800);
    });

    // Remove Event
		$("#update_image_refresh").livequery(function () {
			$(this).tipsy({
	      gravity: "w",
	      offsetBottom: 7
	  });
		return false;
	});
		
		$('#snorby_news, #snorby_bugs, #snorby_wiki, #snorby_footer_info, .add_tipsy').livequery(function () {
			$(this).tipsy({
	      gravity: "s",
	      offsetBottom: 7
	  });
		return false;
	});

		$('#filter_box_link').livequery(function () {
			$(this).tipsy({
	      gravity: "e",
	      offsetBottom: 7
	  });
		return false;
	});

    // DatePicker

    $("#start_datepicker").livequery(function () {
    	$(this).datepicker({
	        duration: '',
	        showTime: true,
	        stepMinutes: 1,
	        stepHours: 1,
	        time24h: false,
	        dateFormat: 'MM d, yy',
					constrainInput: false
	    });
			return false;
    });

    $("#end_datepicker").livequery(function () {
    	$(this).datepicker({
	        duration: '',
	        showTime: true,
	        stepMinutes: 1,
	        stepHours: 1,
	        time24h: false,
	        dateFormat: 'MM d, yy',
					constrainInput: false
	    });
			return false;
    });

		//

    //autocomplete
    $("input#search_keywords").autocomplete("auto_complete_for_search_keywords");
    $("input#search_ip_src").autocomplete("auto_complete_for_search_ip_src");
    $('input#search_ip_dst').autocomplete("auto_complete_for_search_ip_dst");

    // Flash Notice/Error
		$('#flash_notice').slideDown('slow');
		$('#flash_error').slideDown('slow');
		setTimeout("$('#flash_notice').slideUp('slow');", 3000);
		setTimeout("$('#flash_error').slideUp('slow');", 3000);

		// Click Destroy Flash Message
		$('#flash_notice').live('click', function(event) {
			$(this).slideUp('slow', function () {
				$(this).remove();
			});
			return false;
		});
		
		$('#flash_error').live('click', function(event) {
			$(this).slideUp('slow', function () {
				$(this).remove();
			});
			return false;
		});

    // FaceBox
    $('a[rel*=facebox]').livequery(function (event) {
    	$(this).facebox({
					overlay: true,
					opacity: 0.4
	    });
	return false;
    });

    // More
    $('#more').livequery("click", function() {
        var B = $(this);
        B.blur();
        var A = B.attr("href");
        $.ajax({
            url: A + 'page=' + currentPage++,
            type: 'GET',
            dataType: 'script',
            beforeSend: function() {
                $("#more").addClass("loading").html("")
            },
            complete: function() {
                $("#more").removeClass("loading").html("more")
            },
            error: function() {
                alert("Whoops! Something went wrong. Please try refreshing the page.");
            }
        });
			return false;
    });


    // Check ALL
    $("#checkboxall").click(function()
    {
        var checked_status = this.checked;
        $("input[type=checkbox]").each(function()
        {
            this.checked = checked_status;
        });
    });

		// Dashboard
		$(".sortable").sortable({
			axis: 'y',
			helper: 'clone',
			cursor: 'crosshair',
			placeholder: 'loading_move',
			tolerance: 'pointer',
			opacity: 0.4,
			items: 'div.ditem',
			handle: 'div.table_header',
			start: function(event, ui) { 
				//$('object').hide();
			},
			stop: function(event, ui) {
				//$('object').show();
			},
			update: function(event, ui) {
				//console.log(ui);
				//console.log(event);
			},
			change: function(event, ui) {
			}
		});
		
		// Important
		$('a.important').live('click', function() {
			var cid = $(this).attr('event_cid');
			var link = this;
			$(this).html("<img alt='Loading' width='14' height='14' src='../images/ajax.gif' />");
			$('#load_on_change_' + cid).addClass('loading');
			$.get(this.href, function(xml){
				$(link).removeClass('important').addClass('not_important').html("<img alt='Is_not_important' width='14' height='14' src='../images/other/is_not_important.png' />");
			 	$('#load_on_change_' + cid).removeClass('loading');
			});
			return false;
		});
		
		$('a.not_important').live('click', function() {
			var cid = $(this).attr('event_cid');
			var link = this;
			$(this).html("<img alt='Loading' width='14' height='14' src='../images/ajax.gif' />");
			$('#load_on_change_' + cid).addClass('loading');
			$.get(this.href, function(xml){
				$(link).removeClass('not_important').addClass('important').html("<img alt='Is_important' width='14' height='14' src='../images/other/is_important.png' />");
			 	$('#load_on_change_' + cid).removeClass('loading');
			});
			return false;
		});

		$('a.d_hide').live('click', function(event) {
			var i = ".hide_" + $(this).attr('item_name');
			var ishow = this;
			$(i).slideToggle('slow', function () {
				$(ishow).removeClass('d_hide')
				.addClass('d_show')
				.html("<img alt='Show' width='16' height='16' src='../images/dashboard/show.png' />");	
			});
			return false;
		});
		
		$('a.d_show').live('click', function(event) {
			var i = ".hide_" + $(this).attr('item_name');
			var ishow = this;
			$(i).slideToggle('slow', function () {
				$(ishow).removeClass('d_show')
				.addClass('d_hide')
				.html("<img alt='Hide' width='16' height='16' src='../images/dashboard/hide.png' />");	
			});
			return false;
		});

});