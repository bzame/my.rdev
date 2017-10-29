progressBar = function(
	id = NULL
	, value = 0
	, label = FALSE
	, striped = FALSE
	, active = FALSE
	, vertical = FALSE
) {
	stopifnot(is.numeric(value));
	if (value < 0 || value > 100) {
		stop("'value' should be in the range from 0 to 100", call. = FALSE);
	}
	text_value <- paste0(value, "%");
	if (vertical) {
		style = "width: 10px; height: 100%";
	} else {
		style = "width: 100%; height: 10px;"
	}
	class = "progress progress-bar";
	if(vertical) { class = paste(class, "vertical"); }
	if(active) { class = paste(class, "active"); }
	if(striped) { class = paste(class, "progress-bar-striped"); }
	pb = tags$div(
	 	id = id 
	 	, class = class
	 	, style = style
	 	, role = "progressbar"
	 	, `aria-valuenow` = value
	 	, `aria-valuemin` = 0
	 	, `aria-valuemax` = 100
	 	, tags$span(class = if (!label) "sr-only", text_value)
	);
	return(
		pb
	);
}