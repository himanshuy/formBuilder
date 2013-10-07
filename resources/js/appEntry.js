/**
 * @author Himanshu Yadav
 * 
 */
function validateRequiredFields()
{
	$('input,textarea,select').filter('[required]:visible').each(function(i, requiredField){
		
		if($(requiredField).val()=='')
		{
			$(this).closest('div').append("<p class='error-message'>Required field.</p>");
		}
	});
}
function validateWithPRASE(field)
{
	//alert($(field).val());
	$.ajax({
		type:"POST",
		url:"validateWithPrase",
		data: "fieldValue="+$(field).val(),
		success: function(response) {
			var popoverError = 	'<span class="text-error">'+response+'</span>';
			$(field).popover({placement:'right', animation: true, html:true, title:'Prase Error', 
								content:popoverError
							});
			$(field).popover('toggle');
			//$('#praseErrorModal > .modal-body').html('Error: '+response+' for '+field.value);
			//$('#praseErrorModal').modal('toggle');
		},
		error:function (xhRequest, ErrorText, thrownError) {
			alert('Error: '  + '  ' + xhRequest);
		}
	});
}

/*function collectFormData()
{
	$rootElement = $('<FormXMLDoxument/>');
	$formElement = $.createElement($('form').attr('name'));
	$('form').find('div.section').each(function(index, section) {
		var $sectionElement = $.createElement($(section).attr('name'));
		$(section).find('input').each(function(i, field) {
			console.log($(field).attr('name'));
			var $fieldName  = $.createElement($(field).attr('name'));
			$fieldName.text($(field).val());
			$sectionElement.append($fieldName);
		});
		$formElement.append($sectionElement);
	});
	$rootElement.append($formElement);
	console.log('Form XML is '+$rootElement.html());
	return $rootElement.html();					
}*/

function collectFormData()
{
	//$rootElement = $('<FormXMLDoxument/>');
	xmlDoc = document.implementation.createDocument("", "", null);
	root = xmlDoc.createElement($('form').attr('name'));
	var segmentPK='';
	var anotherRoot = '';
	$('form').find('div.section').each(function(index, section) {
		sectionElement = xmlDoc.createElement($(section).attr('name'));
		if($(section).attr('name') == 'CoverageInformation' || $(section).attr('name') == 'RiderInformation')
		{
			segmentPK = "-"+new Date().getTime();
		}
		$(section).find('input:not(label.checkbox :checkbox), select').each(function(i, field) {
			console.log($(field).attr('name'));
			console.log($(field).attr('type'));
			if($(field).attr('name').indexOf('.') != -1)
			{
				anotherRoot = populateMultipleHierarchy(field,xmlDoc);
			} else {
				fieldElement  = xmlDoc.createElement($(field).attr('name'));
			}
			//alert($(field).attr('name'));
			
			if($(field).attr('class')=='multiselect'){
				var arrayValues = $(field).val();
				console.log(arrayValues.length);
				$(arrayValues).each(function(k, v){
					var multiselectElement = xmlDoc.createElement($(field).attr('name'));
					fieldText=xmlDoc.createTextNode(v);
					multiselectElement.appendChild(fieldText);
					sectionElement.appendChild(multiselectElement);
				});
			}
			else if(!fieldElement.hasChildNodes())
			{
				fieldText=xmlDoc.createTextNode($(field).val());
				fieldElement.appendChild(fieldText);
				sectionElement.appendChild(fieldElement);
			}
			
		});
		if(segmentPK != ''||segmentPK != 'undefined') 
		{
			var pkElement = getSegmentPKElement($(section).attr('name'),segmentPK);
			sectionElement.appendChild(pkElement);
		}
		root.appendChild(sectionElement);
		if(anotherRoot != '') {
			root.appendChild(anotherRoot);
		}
		
	});
	xmlDoc.appendChild(root, xmlDoc);
	console.log((new XMLSerializer()).serializeToString(xmlDoc));
	return (new XMLSerializer()).serializeToString(xmlDoc);					
}

function getSegmentPKElement(sectionName, segmentPK)
{
	xmlDoc = document.implementation.createDocument("", "", null);
	
	if(sectionName == 'CoverageInformation' || sectionName == 'RiderInformation')
	{
		pkElement = xmlDoc.createElement('SegmentPK');
		
	} else {
		pkElement = xmlDoc.createElement('SegmentFK');
	}
	pkText = xmlDoc.createTextNode(segmentPK);
	pkElement.appendChild(pkText);
	return pkElement;
}

function populateMultipleHierarchy(field)
{
	var fieldArray = new Array();
	fieldArray = $(field).attr('name').split(".");
	console.log(fieldArray)
	for(i=0; i<fieldArray.length-1; i++)
	{
		ele = xmlDoc.createElement(fieldArray[i]);
		//if(i==fieldArray.length-1)
		//{
		childEle = xmlDoc.createElement(fieldArray[i+1]);
		childText=xmlDoc.createTextNode($(field).val());
		childEle.appendChild(childText);
		//}
		ele.appendChild(childEle);
	}
	console.log((new XMLSerializer()).serializeToString(ele))
	return ele;
}

$.createElement = function(name)
{
	console.log('Creating Element '+name);
	return $('<'+ name +' />');
}

function loadFormData()
{
	$('form').find('div.section').each(function(index, section) {
		var sectionDoc = matchSectionName($(section).attr('name'));
		$(section).find('input').each(function(i, field) {
			for(i=0;i<sectionDoc.childNodes.length;i++)
			{	
				if(sectionDoc.childNodes[i].nodeName==$(field).attr('name'))
				{
					$(field).val($(sectionDoc.childNodes[i]).text());
				}
				
			}
		});
	});	
}

function matchSectionName(sectionName)
{
	for(i=0;i< modelSectionDoc.length;i++)
	{
		console.log(modelSectionDoc[i].nodeName);
		if(modelSectionDoc[i].nodeName == sectionName)
		{
			return modelSectionDoc[i];
			break;
		}
	}
}
function firstSectionIsVisible()
{
	var isFirstSectionVisible=false;
	$('.section').each(function(i, section){
		if($(section).is(':visible').attr('id')==$(sectionArray[0]))
		{
			isFirstSectionVisible = true;
		}
			
	});
}
function lastSectionIsVisible(section)
{
	var arrayLength = sectionArray.length;
	//alert($(section).attr('id'));
	//alert($(sectionArray[arrayLength-1]).attr('id'));
	if($(section).attr('id')==$(sectionArray[arrayLength-1]).attr('id'))
	{
		$('#next').attr('disabled','disabled');
	}
		
}

function showChildFields(field, childFieldsArray)
{
	var childFields = childFieldsArray.split('~');
	if(field.type=='select-one')
	{
		clearFieldsForDropdown(field, childFieldsArray);
	}
	for(i=0; i<childFields.length;i++)
	{
		var childFieldsForEachValue = childFields[i].split(':');
		if(childFieldsForEachValue[0]==field.value)
		{
			toggleChildFields(field, childFields);
		}
	}
	
}
function clearFieldsForDropdown(field, childFieldsArray)
{
	var parentValues = childFieldsArray.split(':');
	if(parentValues.indexOf(field.value)==-1)
	{
		var fieldName = $(field).attr('name');
		var childFieldDivId = '#parent-'+fieldName;
		$(childFieldDivId).hide();
		$(childFieldDivId).find('div').each(function(i, childField){
			$(childField).hide();
		});
	}
}
function toggleChildFields(field, childFields)
{
	var childFieldsForEachValue = childFields[i].split(':');
	var fieldsArray = childFieldsForEachValue[1].split(',');
	var fieldName = $(field).attr('name');
	var childFieldDivId = '#parent-'+fieldName;
	$(childFieldDivId).show();
	$(childFieldDivId).find('div').each(function(i, childField){
		if(fieldsArray.indexOf($(childField).attr('name')) != -1) {
			$(childField).show();
		} else {
			
			$(childField).hide();
		}
	});
}

/*function validateRequiredFields()
{
	$('input').attr('required',true).each(function(i, field){
		alert('Comes to validateRequiredFields: '+$(field).attr('name'));
	});
}*/