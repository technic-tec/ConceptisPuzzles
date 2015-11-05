/*

CUSTOM FORM ELEMENTS

Created by Ryan Fait
www.ryanfait.com

The only things you may need to change in this file are the following
variables: checkboxHeight, radioHeight and selectWidth (lines 24, 25, 26)

The numbers you set for checkboxHeight and radioHeight should be one quarter
of the total height of the image want to use for checkboxes and radio
buttons. Both images should contain the four stages of both inputs stacked
on top of each other in this order: unchecked, unchecked-clicked, checked,
checked-clicked.

You may need to adjust your images a bit if there is a slight vertical
movement during the different stages of the button activation.

The value of selectWidth should be the width of your select list image.

Visit http://ryanfait.com/ for more information.

*/
var checkboxHeight = "25";
var radioHeight = "25";
var selectWidth = "126";
function preloadFilters() {
	var pap, lap, fap, map, dap, sap, sud, kak, hit, bat, sli, has, cal;
	pap = new Image(126, 16);
	lap = new Image(126, 16);
	fap = new Image(126, 16);
	map = new Image(126, 16);
	dap = new Image(126, 16);
	sap = new Image(126, 16);
	sud = new Image(126, 16);
	kak = new Image(126, 16);
	hit = new Image(126, 16);
	bat = new Image(126, 16);
	sli = new Image(126, 16);
	has = new Image(126, 16);
	cal = new Image(126, 16);
	sap.src = "../../picture/36/2165.gif";
	cal.src = "../../picture/36/1635.gif";
	has.src = "../../picture/36/1003.gif";
	sli.src = "../../picture/36/278.gif";
	sud.src = "../../picture/36/164.gif";
	bat.src = "../../picture/36/146.gif";
	lap.src = "../../picture/36/135.gif";
	map.src = "../../picture/36/127.gif";
	fap.src = "../../picture/36/85.gif";
	hit.src = "../../picture/36/73.gif";
	pap.src = "../../picture/36/132.gif";
	dap.src = "../../picture/36/58.gif";
	kak.src = "../../picture/36/27.gif";
}
document.write('<style type="text/css">input.styled { display: none; } select.styled { position: relative; width: ' + selectWidth + 'px; opacity: 0; filter: alpha(opacity=0); z-index: 5; height: 17px; } .disabled { opacity: 0.5; filter: alpha(opacity=50); }</style>');
var Custom = {
	init: function() {
		var inputs = document.getElementsByTagName("input"),
			span = Array(), textnode, option, active;
		for (a = 0; a < inputs.length; a++) {
			if ((inputs[a].type == "checkbox" || inputs[a].type == "radio") && inputs[a].className == "styled") {
				span[a] = document.createElement("span");
				span[a].className = inputs[a].type;
				if (inputs[a].checked == true) {
					if (inputs[a].type == "checkbox") {
						position = "0 -" + (checkboxHeight * 2) + "px";
						span[a].style.backgroundPosition = position;
					}
					else {
						position = "0 -" + (radioHeight * 2) + "px";
						span[a].style.backgroundPosition = position;
					}
				}
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				inputs[a].onchange = Custom.clear;
				if (!inputs[a].getAttribute("disabled")) {
					span[a].onmousedown = Custom.pushed;
					span[a].onmouseup = Custom.check;
				}
				else {
					span[a].className = span[a].className += " disabled";
				}
			}
		}
		inputs = document.getElementsByTagName("select");
		for (a = 0; a < inputs.length; a++) {
			if (inputs[a].className == "styled") {
				option = inputs[a].getElementsByTagName("option");
				active = option[0].childNodes[0].nodeValue;
				textnode = document.createTextNode(active);
				for (b = 0; b < option.length; b++) {
					if (option[b].selected == true) {
						textnode = document.createTextNode(option[b].childNodes[0].nodeValue);
					}
				}
				span[a] = document.createElement("span");
				span[a].className = "select";
				span[a].id = "select" + inputs[a].name;
				span[a].appendChild(textnode);
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				if (!inputs[a].getAttribute("disabled")) {
					inputs[a].onchange = Custom.choose;
				}
				else {
					inputs[a].previousSibling.className = inputs[a].previousSibling.className += " disabled";
				}
			}
		}
		document.onmouseup = Custom.clear;
	}
, pushed: function() {
	element = this.nextSibling;
	if (element.checked == true && element.type == "checkbox") {
		this.style.backgroundPosition = "0 -" + checkboxHeight * 3 + "px";
	}
	else if (element.checked == true && element.type == "radio") {
		this.style.backgroundPosition = "0 -" + radioHeight * 3 + "px";
	}
	else if (element.checked != true && element.type == "checkbox") {
		this.style.backgroundPosition = "0 -" + checkboxHeight + "px";
	}
	else {
		this.style.backgroundPosition = "0 -" + radioHeight + "px";
	}
},
	check: function() {
		element = this.nextSibling;
		if (element.checked == true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 0";
			element.checked = false;
		}
		else {
			if (element.type == "checkbox") {
				this.style.backgroundPosition = "0 -" + checkboxHeight * 2 + "px";
			}
			else {
				this.style.backgroundPosition = "0 -" + radioHeight * 2 + "px";
				group = this.nextSibling.name;
				inputs = document.getElementsByTagName("input");
				for (a = 0; a < inputs.length; a++) {
					if (inputs[a].name == group && inputs[a] != this.nextSibling) {
						inputs[a].previousSibling.style.backgroundPosition = "0 0";
					}
				}
			}
			element.checked = true;
		}
	},
	clear: function() {
		inputs = document.getElementsByTagName("input");
		for (var b = 0; b < inputs.length; b++) {
			if (inputs[b].type == "checkbox" && inputs[b].checked == true && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + checkboxHeight * 2 + "px";
			}
			else if (inputs[b].type == "checkbox" && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			}
			else if (inputs[b].type == "radio" && inputs[b].checked == true && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + radioHeight * 2 + "px";
			}
			else if (inputs[b].type == "radio" && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			}
		}
	},
	choose: function() {
		option = this.getElementsByTagName("option");
		for (d = 0; d < option.length; d++) {
			if (option[d].selected == true) {
				document.getElementById("select" + this.name).childNodes[0].nodeValue = option[d].childNodes[0].nodeValue;
				disableFilters();
				applyFilter(this.name, option[d].value);
			}
		}
	}
}

function getSelectedOption(selectName) {
	var optionValue = "";
	if (document.getElementsByName(selectName).length > 0) {
		var selectField = document.getElementsByName(selectName)[0];
		var option = selectField.getElementsByTagName("option");
		for (b = 0; b < option.length; b++) {
			if (option[b].selected == true) {
				optionValue = option[b].value;
			}
		}
	}
	else {
		optionValue = "-";
	}
	return optionValue;
}
function applyFilter(selectName, selectedValue) {
	var newuri = getBaseUri();
	var variant = getSelectedOption("variant");
	var model = getSelectedOption("model");
	var diff = getSelectedOption("difficulty");
	if (variant != "-") {
		newuri += "/variant/" + variant;
	}
	if (model != "-") {
		newuri += "/model/" + model;
	}
	if (diff != "-") {
		newuri += "/difficulty/" + diff;
	}
	window.location.href = (newuri);
}

function disableFilters() {
	var selects = document.getElementsByTagName("select");
	for (var i = 0; i < selects.length; i++) {
		i.disabled = true;
	}
	document.getElementById("filtercombos").style.display = "none";
	document.getElementById("updatemsg").style.display = "block";
	document.getElementById("updatemsg").style.zIndex = "3";
}

function resetFilter() {
	disableFilters();
	window.location.href = getBaseUri();
}

function getBaseUri() {
	var url = window.location.href;
	var address = url.substring(0, url.indexOf("?"));
	var uri = url.substring(url.indexOf("uri=") + 4);
	var params = uri.split("/");
	var newuri = params[0] + "/" + params[1] + "/" + params[2] + "/" + params[3];
	return (address + "?uri=" + newuri);
}