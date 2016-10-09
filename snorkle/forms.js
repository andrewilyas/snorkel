var convValidator = {
		fields: {
			"conv-size": {
				identifier: "conv-size",
				rules: [{
					type: "regExp",
					value: /(\d{1,3}),(\d{1,3})/i
				}]
			},
			"feat-maps": {
				identifier: "feat-maps",
				rules: [{
					type: "empty"
				}]
			},
			"input-channels": {
				identifier: "input-channels",
				rules: [{
					type: "empty"
				}]
			},
		},
		onSuccess: function(e) {
			e.preventDefault();
			return false;
		},
		onFailure: function() {
			return false;
		}
	};

var poolValidator = {
		fields: {
			"pool-size": {
				identifier: "pool-size",
				rules: [{
					type: "regExp",
					value: /(\d{1,3}),(\d{1,3})/i
				}]
			}
		},
		onSuccess: function(e) {
			e.preventDefault();
			return false;
		},
		onFailure: function() {
			return false;
		}
	};

var linearValidator = {
		fields: {
			"linear-size": {
				identifier: "linear-size",
				rules: [{
					type: "empty"
				}]
			},
			"output-size": {
				identifier: "linear-size",
				rules: [{
					type: "empty"
				}]
			}
		},
		onSuccess: function(e) {
			e.preventDefault();
			return false;
		},
		onFailure: function() {
			return false;
		}
	};


function makeConvForm() {
	var form = document.createElement("form");
	form.onsubmit = "return false;"
	addClass(form, "ui");
	addClass(form, "form");
	addClass(form, "conv")

	form.appendChild(makeField("Number of input channels", "number", "input-channels", "1"));
	form.appendChild(makeField("Number of feature maps", "number", "feat-maps", "1"));
	form.appendChild(makeField("Convolution field size", "text", "conv-size", "Width,Height"));
	$(form).form(convValidator);
	return form;
}

function makeLinearForm() {
	var form = document.createElement("form");
	addClass(form, "ui");
	addClass(form, "form");
	addClass(form, "lin");

	form.appendChild(makeField("Input Size", "number", "linear-size", false));
	form.appendChild(makeField("Output Size", "number", "output-size", false));
	$(form).form(linearValidator);
	return form;
}

function makePoolForm() {
	var form = document.createElement("form");
	addClass(form, "ui");
	addClass(form, "form");
	addClass(form, "pool");

	form.appendChild(makeField("Pool Region Size", "text", "pool-size", "Width,Height"));
	$(form).form(poolValidator);
	return form;
}

function parseForm(layerId) {
	var theForm = $("#" + layerId + " form");
	var formElements;
	var retString = "";

	if (theForm.hasClass("conv")) {
		formElements = ["input-channels", "feat-maps", "conv-size"]
	} else if (theForm.hasClass("pool")) {
		formElements = ["pool-size"]
	} else if (theForm.hasClass("lin")) {
		formElements = ["linear-size", "output-size"]
	}

	for (var i = 0; i < formElements.length; i++) {
		retString += theForm.find("input[name='" + formElements[i] + "']").val() + ",";
	}
	return retString.slice(0, -1);
}

function makeField(labelText, inputType, inputName, inputPlaceholder) {
	var fieldDiv = document.createElement("div");
	addClass(fieldDiv, "field");

	var label = document.createElement("label");
	label.innerText = labelText;
	fieldDiv.appendChild(label);

	var input = document.createElement("input");
	input.type = inputType;
	input.name = inputName;
	if (inputPlaceholder) { input.placeholder = inputPlaceholder; }
	fieldDiv.appendChild(input);

	return fieldDiv;
}