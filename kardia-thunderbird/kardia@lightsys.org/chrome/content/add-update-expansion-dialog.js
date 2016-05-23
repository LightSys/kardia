var XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

// Dialog parameters
var kardiacrm = window.arguments[0];
var composeWindow = window.arguments[1];
var selected_text = window.arguments[2];
var current_tag = window.arguments[3];
var callback = window.arguments[4];


// Model code for text expansion object
var modelTextExpansion = {
	Create: function(id, props, cb) {
		var date = new Date();
		kardiacrm.requestPost("crm_config/TextExpansions", 
				{
				e_exp_tag: id,
				e_exp_desc: props.description,
				e_exp_expansion: props.expansion,
				s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
				s_created_by: kardiacrm.username,
				s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
				s_modified_by: kardiacrm.username,
				},
			'textexp', null, function(resp) {
				if (resp && resp.Location && resp.Data) {
					delete resp["@id"];
					kardiacrm.data.textExpList[id] = (resp.Data);
					return cb(true);
				}
				cb(false);
			}
		);
	},

	Modify: function(id, props, cb) {
		var date = new Date();
		kardiacrm.requestPatch("crm_config/TextExpansions/" + id, 
				{
				description: props.description,
				expansion: props.expansion,
				s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
				s_modified_by: kardiacrm.username,
				},
			'textexp', null, function(resp) {
				for(var i in kardiacrm.data.textExpList) {
					if (kardiacrm.data.textExpList[i].tag == id) {
						kardiacrm.data.textExpList[i].description = props.description;
						kardiacrm.data.textExpList[i].expansion = props.expansion;
						return cb(true);
					}
				}
				cb(false);
			}
		);
	},
};


// Controller code -- here is where we make stuff happen.
var controller = {
	// Whether the user has modified the description/expansion
	modified: false,

	// This saves data on the screen.
	//
	cmdSave: function() {
		// Creating a new expansion
		if ($("#exp-tag").prop("value") != "" && $("#exp-list-dropdown").prop("value") == "") {
			modelTextExpansion.Create($("#exp-tag").prop("value"), {description:$("#exp-desc").prop("value"), expansion:$("#exp-expansion").prop("value")}, function(stat) {
				callback(stat);
			});
		}

		// Modifying an expansion
		if ($("#exp-list-dropdown").prop("value") != "") {
			modelTextExpansion.Modify($("#exp-tag").prop("value"), {description:$("#exp-desc").prop("value"), expansion:$("#exp-expansion").prop("value")}, function(stat) {
				callback(stat);
			});
		}
		return true;
	},


	// This cancels out
	cmdCancel: function() {
		callback(false);
		return true;
	},


	// This is called when the user selects a different expansion
	// item from the dropdown, or selects "(add new)" to tell us that
	// a new expansion needs to be created.
	//
	cmdSelectAddUpdate: function() {
		var cur_value = $("#exp-list-dropdown").prop("value");
		if (cur_value == "") {
			// Adding
			controller.modified = false;
			$("#exp-tag").removeProp("disabled");
			$("#exp-tag").prop("value", "");
			$("#exp-desc").prop("value", "");
			$("#exp-expansion").prop("value", "");
		}
		else {
			// Updating
			$("#exp-tag").prop("disabled", true);
			$("#exp-tag").prop("value", cur_value);
			$("#exp-warn").prop("value", "");

			// Fill in the description and expansion based on what was selected.
			for(var i in kardiacrm.data.textExpList) {
				var one_exp = kardiacrm.data.textExpList[i];
				if (one_exp.tag == cur_value) {
					$("#exp-desc").prop("value", one_exp.description);
					$("#exp-expansion").prop("value", one_exp.expansion);
					break;
				}
			}
		}

		controller.cmdEvaluate();
	},


	// This is called whenever the user modifies the expansion text
	// or the description fields.
	//
	cmdModifyDescExp: function() {
		controller.modified = true;
		controller.cmdEvaluate();
	},


	// This is called each time something changes in the dialog,
	// so we can keep everything properly in sync.
	//
	cmdEvaluate: function() {
		// Does the new tag already exist?  Warn user if so.
		var exists = false;
		for(var i in kardiacrm.data.textExpList) {
			if (kardiacrm.data.textExpList[i].tag == $("#exp-tag").prop("value") && $("#exp-list-dropdown").prop("value") == "") {
				exists = true;
			}
		}
		if (exists) {
			$("#exp-warn").prop("value", "Error: Tag already exists");
		}
		else if ($("#exp-list-dropdown").prop("value") == "" && $("#exp-tag").prop("value") == "" && controller.modified) {
			$("#exp-warn").prop("value", "Error: Tag required");
		}
		else {
			$("#exp-warn").prop("value", "");
		}

		// Use selection from editor if user has not touched this stuff yet.
		if (!controller.modified) {
			// If a selection is provided, set the expansion text to the selection.
			if (selected_text) {
				$("#exp-expansion").prop("value", selected_text);
			}
		}
	},


	// Called once when the dialog opens.
	//
	cmdInitialize: function() {
		// Center the dialog
		centerWindowOnScreen();

		controller.modified = false;

		// Load the expansion types list
		$("#exp-list-dropdown menupopup")
			.empty()
			.append(
				$("<menuitem>", {
					value: "",
					label: "(add new)",
				})
			);
		for (var i in kardiacrm.data.textExpList) {
			var textexp = kardiacrm.data.textExpList[i];
			$("#exp-list-dropdown menupopup")
				.append(
					$("<menuitem>", {
						value: textexp.tag,
						label: '(update) ' + textexp.tag + ' - ' + textexp.description,
					})
				);
		}

		// Select a tag if provided, otherwise select "(add new)"
		$("#exp-list-dropdown").prop("value", current_tag?current_tag:"");

		// Catch event handlers.
		$("#exp-list-dropdown").bind("command", function(event) {
			controller.cmdSelectAddUpdate();
		});
		$("#exp-tag").bind("change", function(event) {
			controller.cmdEvaluate();
		});
		$("#exp-desc").bind("change", function(event) {
			controller.cmdModifyDescExp();
		});
		$("#exp-expansion").bind("change", function(event) {
			controller.cmdModifyDescExp();
		});

		// Call the generalized re-evaluation function
		controller.cmdSelectAddUpdate();
	},
};

