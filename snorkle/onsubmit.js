function askForInputs () {
	$('.ui.modal#inputs').modal('show');
}

function submitInput() {
	allString += "\n\n"
	if($("input#text").prop('checked')) {
		allString += "function dataLoader()\n\treturn textLoader('rt-polarity.all', 28, 28)\nend"
	} else {
		//allString += "function dataLoader()\n\treturn imageLoader('mnist_png/training', 28, 28)\nend"
		allString += "function dataLoader()\n\treturn imageLoader('training', 28, 28)\nend\n"
		allString += "\nfunction testLoader()\n\treturn imageLoader('testing', 28, 28)\nend\n"
	}

	var loaderDiv = document.createElement("div");
	addClass(loaderDiv, "loader");
	document.body.appendChild(loaderDiv);

	$.ajax({
		'url': '/train_model',
		'method': 'POST',
		'data': {
			'message': allString,
			'image_url': $("#training_url").val(),
			'test_url': $("#testing_url").val()
		}
	}).done(function(data) {
		$("#test_accuracy").text(data);
		$(".loader").remove();
		$('.ui.modal#outputs').modal('show');
	});
}

function requestOutput() {
	$.ajax({
		'url': '/classify_this',
		'method': 'POST',
		'data': {
			'image_url': $("#image_url").val()
		}
	}).done(function(data) {
		$('#classifier_result').text(data);
	});
}
