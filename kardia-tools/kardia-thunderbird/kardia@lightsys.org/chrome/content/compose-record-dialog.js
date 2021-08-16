var XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"].getService(Components.interfaces.mozIJSSubScriptLoader);
loader.loadSubScript("chrome://kardia/content/jquery-1.11.1.js", window);

var recipientAddresses = window.arguments[0];
var recipientFirstNames = window.arguments[1];
var recipientLastNames = window.arguments[2];
var kardiaAddresses = window.arguments[3];
var kardiaNames = window.arguments[4];
var kardiacrm = window.arguments[5];
var myId = window.arguments[6];
var messageWindow = window.arguments[7];

//when the dialog opens, center dialog
function startDialog() {
	// move to center of parent window
	centerWindowOnScreen();

	var master = document.getElementById('dialog-section-0');

	var changeIds = function(list, index) {
		list.forEach(function(node, currentIndex, listObj) {
			var id = node.id;
			if (id) node.id = id.slice(0, id.lastIndexOf('-')+1) + index;
			if (node.hasChildNodes) changeIds(node.childNodes, index);
		});
	};

	for (var i = 1; i < recipientAddresses.length; i++) {
		var clone = master.cloneNode(true);
		clone.id = "dialog-section-" + i;
		changeIds(clone.childNodes, i);
		var separator = document.createElement('separator');
		separator.setAttribute("class", "groove");
		document.getElementById('compose-record-dialog').appendChild(separator);
		document.getElementById('compose-record-dialog').appendChild(clone);
		setupSection(i);
	}

	// This must be last because everything is copied from it
	setupSection(0);
}

// when you click cancel, tell the main script
function saveChoices(){
	// messageWindow.creatingPartner, etc have been set

	for (var i=0; i<recipientAddresses.length; i++) {
		// return creatingCollab if a role was selected
		messageWindow.creatingCollab[i] = messageWindow.creatingPartner[i] && $("#dialog-newperson-role-" + i)[0].value;

		// return new partner email/first/last, if necessary
		if (messageWindow.creatingPartner[i]) {
			messageWindow.curData.email[i] = $("#dialog-newperson-email-" + i)[0].value;
			messageWindow.curData.first[i] = $("#dialog-newperson-first-" + i)[0].value;
			messageWindow.curData.last[i] = $("#dialog-newperson-last-" + i)[0].value;
			messageWindow.curData.roletype[i] = $("#dialog-newperson-role-" + i)[0].value;
			if (messageWindow.curData.roletype[i]) kardiacrm.last_role_type = messageWindow.curData.roletype[i];
		}

		// return todo type/days/assignto/comment, if necessary
		if (messageWindow.creatingTodo[i]) {
			messageWindow.curData.todotype[i] = $("#dialog-todo-type-" + i)[0].value;
			if (messageWindow.curData.todotype[i]) kardiacrm.last_todo_type = messageWindow.curData.todotype[i];
			messageWindow.curData.days[i] = $("#dialog-todo-days-" + i)[0].value;
			if (messageWindow.curData.days[i]) kardiacrm.last_due_days = messageWindow.curData.days[i];
			messageWindow.curData.assignee[i] = $("#dialog-todo-assignee-" + i)[0].value;
			if (messageWindow.curData.assignee[i]) kardiacrm.last_assignee = messageWindow.curData.assignee[i];
			messageWindow.curData.todo_comment[i] = $("#dialog-todo-comment-" + i)[0].value;
		}

	}

	return true;
}

function setupSection(index) {
	var email = recipientAddresses[index];
	var kardiaIndex = kardiaAddresses.indexOf(email);
	
	if (kardiaIndex >= 0) {
		$("#dialog-person-name-" + index).prop("value", kardiaNames[kardiaIndex] + " <" + email + ">");
	}
	else {
		// doesn't exist, so prefill the newperson box
		$("#dialog-newperson-email-" + index).prop("value", email);

		if (messageWindow.creatingPartner[index]) {
			// we have already chosen to create partner when opening this dialog previously
			$("#dialog-record-contact-" + index).prop("checked", true);
			$("#dialog-person-name-" + index).prop("value", messageWindow.curData.first[index] + " " + messageWindow.curData.last[index] + " <" + email + ">");
            $("#dialog-newperson-first-" + index).prop("value", messageWindow.curData.first[index]);
			$("#dialog-newperson-last-" + index).prop("value", messageWindow.curData.last[index]);
		}
		else if (recipientFirstNames[index] && recipientLastNames[index]) {
			// name not null
			$("#dialog-person-name-" + index).prop("value", recipientFirstNames[index] + " " + recipientLastNames[index] + " <" + email + ">");
            $("#dialog-newperson-first-" + index).prop("value", recipientFirstNames[index]);
			$("#dialog-newperson-last-" + index).prop("value", recipientLastNames[index]);
		}
		else {
			$("#dialog-person-name-" + index).prop("value", "<" + email + ">");
		}

		// Fill in the role options
		$("#dialog-newperson-role-" + index + " menupopup")
			.empty()
			.append(
				$("<menuitem>", {
					value: '',
					label: '(none)',
				})
			);
		for (var i in kardiacrm.data.collabTypeList) {
			$("#dialog-newperson-role-" + index + " menupopup")
				.append(
					$("<menuitem>", {
						value: '' + i,
						label: kardiacrm.data.collabTypeList[i].label,
					})
				);
		}
		
		if (messageWindow.creatingPartner[index]) {
			$("#dialog-newperson-role-" + index)[0].value = messageWindow.curData.roletype[index];
		}
		else if (kardiacrm.last_role_type !== null) {
			$("#dialog-newperson-role-" + index)[0].value = kardiacrm.last_role_type;
		}
	}

	$("#dialog-record-contact-" + index).click(function(event) {
		setSectionVisibility(index);
	});
	$("#dialog-record-future-" + index).click(function(event) {
		setSectionVisibility(index);
	});

	$("#dialog-record-todo-" + index).click(function(event) {
		setSectionVisibility(index);
	});

	// Fill in the task type options and assignee options
	$("#dialog-todo-type-" + index + " menupopup").empty();
	for (var i in kardiacrm.data.todoTypeList) {
		$("#dialog-todo-type-" + index + " menupopup")
			.append(
				$("<menuitem>", {
					value: '' + i,
					label: kardiacrm.data.todoTypeList[i].type_label,
				})
			);
		if (kardiacrm.last_todo_type)
			$("#dialog-todo-type-" + index)[0].value = kardiacrm.last_todo_type;
	}
	$("#dialog-todo-assignee-" + index + " menupopup").empty();
	for (var i in kardiacrm.data.staffList) {
		if (kardiacrm.data.staffList[i].is_staff && kardiacrm.data.staffList[i].kardia_login) {
			$("#dialog-todo-assignee-" + index + " menupopup")
				.append(
					$("<menuitem>", {
						value: kardiacrm.data.staffList[i].partner_id,
						label: kardiacrm.data.staffList[i].partner_name,
					})
				);
			if (kardiacrm.last_assignee)
				$("#dialog-todo-assignee-" + index)[0].value = kardiacrm.last_assignee;
			else
				$("#dialog-todo-assignee-" + index)[0].value = myId;
		}
	}
	if (kardiacrm.last_due_days)
		$("#dialog-todo-days-" + index)[0].value = '' + kardiacrm.last_due_days;
	
	// if dialog previously opened and Autorecord or Task checked, check now
	if (messageWindow.creatingAutorecord[index]) {
		$("#dialog-record-future-" + index).prop("checked", true);
	}
	if (messageWindow.creatingTodo[index]) {
		$("#dialog-record-todo-" + index).prop("checked", true);
		$("#dialog-todo-type-" + index).prop("value", messageWindow.curData.todotype[index]);
		$("#dialog-todo-days-" + index).prop("value", messageWindow.curData.days[index]);
		$("#dialog-todo-assignee-" + index).prop("value", messageWindow.curData.assignee[index]);
		$("#dialog-todo-comment-" + index).prop("value", messageWindow.curData.todo_comment[index]);
	}

	setSectionVisibility(index);
}

function setSectionVisibility(index) {
	messageWindow.creatingContactHistory[index] = $('#dialog-record-contact-' + index).prop("checked");
	messageWindow.creatingAutorecord[index] = $('#dialog-record-future-' + index).prop("checked");
	messageWindow.creatingTodo[index] = $('#dialog-record-todo-' + index).prop("checked");
	
	var alreadyInKardia = (kardiaAddresses.indexOf(recipientAddresses[index]) >= 0);
	messageWindow.creatingPartner[index] =
		!alreadyInKardia &&	(	messageWindow.creatingContactHistory[index] ||
								messageWindow.creatingAutorecord[index]		||
								messageWindow.creatingTodo[index]);
	messageWindow.creatingLocation[index] = messageWindow.creatingPartner[index];
	messageWindow.creatingEmail[index] = messageWindow.creatingPartner[index];

	$('#dialog-newperson-box-' + index).prop("hidden", !messageWindow.creatingPartner[index]);
	$('#dialog-todo-box-' + index).prop("hidden", !messageWindow.creatingTodo[index]);
}
