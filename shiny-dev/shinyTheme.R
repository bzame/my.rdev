
# available theme list
allThemes = function() {
	# themes <- dir(
	#     system.file("shinythemes/css", package = "shinythemes")
	#     , "*.min.css"
	# );
	themes = dir("www/css/", "*.min.css");
	sub(".min.css", "", themes);
}



# dynamic theme loading
themeSelector = function() {
	div(
		div(class = "panel panel-primary",
			style = "box-shadow: 5px 5px 15px -5px rgba(0, 0, 0, 0.3);",
			div(class = "panel-heading", "Select theme:"),
			div(class = "panel-body",
				selectInput("shinytheme-selector", NULL,
							c("default", allThemes()),
							selectize = FALSE
				)
			)
		)
		, tags$script(
			"$('#shinytheme-selector')
			.on('change', function(el) {
				var allThemes = $(this).find('option').map(function() {
					if ($(this).val() === 'default')
						return 'bootstrap';
					else
						return $(this).val();
				});
				// Find the current theme
				var curTheme = el.target.value;
				if (curTheme === 'default') {
					curTheme = 'bootstrap';
					curThemePath = 'shared/bootstrap/css/bootstrap.min.css';
				} else {
					curThemePath = 'css/' + curTheme + '.min.css';
				}
				// Find the <link> element with that has the bootstrap.css
				var $link = $('link').filter(function() {
					var theme = $(this).attr('href');
					theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');
					return $.inArray(theme, allThemes) !== -1;
				});
				// Set it to the correct path
				$link.attr('href', curThemePath);
			});"
		)
		)
	}
