/**
 * @author Himanshu Yadav
 * 
 * All the javascript functions related to ClientInformation sections will belong to this file. Currently it has functions for:
 * 1. ClientSearch
 * 
 */
var clientSearchResponse;

function populateClientSection(row)
{
	var fullName = $(row).find('.ClientName').text().split(",");
	var clientDetailPK = $(row).find('.ClientDetailPK').text();
	var selectedClientDetail = getSelectedClientDetailXml(clientDetailPK)
	var dateOfBirth = $(row).find('.DateOfBirth').text();
	$(row).find('td').each(function(i, tdElement){
		$('#'+$('#parentSectionOfClientSearch').text()).find('input,select').each(function(i, field){
			var fieldName = $(field).attr('name');
			
			if($(selectedClientDetail).find(fieldName).text() != '')
			{
				$(field).val($(selectedClientDetail).find(fieldName).text());
				$(field).attr("disabled","disabled");
			}
			
			if($(field).attr('name')==$(tdElement).attr('class'))
			{
				$(field).val($(tdElement).text());
			}
			else if($(field).attr('name')=='FirstName')
			{
				$(field).val(fullName[1]);
				$(field).attr("disabled","disabled");
			}
			else if($(field).attr('name')=='LastName')
			{
				$(field).val(fullName[0]);
				$(field).attr("disabled","disabled");
			}
			else if($(field).attr('name')=='DateOfBirth')
			{
				$(field).val(dateOfBirth);
				$(field).attr("disabled","disabled");
			}
		});
		
	});
	$('#'+$('#parentSectionOfClientSearch').text())
					.append('<div class="row field" style="display:none">'+
							'<input type="text" name="ClientDetailPK" value='+clientDetailPK+'></div>"');
	
}

function getSelectedClientDetailXml(clientDetailPK)
{
	var selectedClientDetail
	$($.parseXML(clientSearchResponse)).find("ClientDetailVO").each(function(){
		
		if($(this).find('ClientDetailPK').text() == clientDetailPK)
		{
			selectedClientDetail = this;
			return false;
		}
	});
	return selectedClientDetail;
}

function requestForClientSearch()
{
	var requestXML= $.parseXML('<?xml version="1.0" encoding="UTF-8"?><SEGRequestVO><Service>Search</Service><Operation>executeSearch</Operation><Operator>N/A</Operator><IgnoreEditWarningsUI>false</IgnoreEditWarningsUI><IgnoreEditWarningsNF>false</IgnoreEditWarningsNF><RequestParameters><SearchCommand>FIND_BY_CLIENT_NAME</SearchCommand><RecordPRASE>false</RecordPRASE><RecordHTTPRequest>false</RecordHTTPRequest></RequestParameters></SEGRequestVO>');
	var requestParam = $(requestXML).find('RequestParameters').get(0);
	if($('#searchClientName').val() != '')
	{
		var item = $.parseXML('<ClientName>'+$('#searchClientName').val()+'</ClientName>');
		$(requestParam).append($(item).children(0));
	} else if($('#searchPolicyNumber').val() != '')
	{
		var item = $.parseXML('<PolicyNumber>'+$('#searchPolicyNumber').val()+'</PolicyNumber>');
		$(requestParam).append($(item).children(0));
	}
	
	console.log(requestXML);
	return requestXML;
	    
}

function requestClientSearchForPolicySave()
{
	var requestXML= $.parseXML('<?xml version="1.0" encoding="UTF-8"?><SEGRequestVO><Service>Client</Service><Operation>getClientsByName</Operation><Operator>N/A</Operator><IgnoreEditWarningsUI>false</IgnoreEditWarningsUI><IgnoreEditWarningsNF>false</IgnoreEditWarningsNF><RequestParameters><CaseInsuredOnly>N</CaseInsuredOnly><RecordPRASE>false</RecordPRASE><RecordHTTPRequest>false</RecordHTTPRequest></RequestParameters></SEGRequestVO>');
	var requestParam = $(requestXML).find('RequestParameters').get(0);
	if($('#searchClientName').val() != '')
	{
		var item = $.parseXML('<Name>'+$('#searchClientName').val()+'</Name>');
		$(requestParam).append($(item).children(0));
	} else if($('#searchPolicyNumber').val() != '')
	{
		var item = $.parseXML('<PolicyNumber>'+$('#searchPolicyNumber').val()+'</PolicyNumber>');
		$(requestParam).append($(item).children(0));
	}
	
	console.log(requestXML);
	return requestXML;
}

function parseClientSearchResponse(response)
{
	clientSearchResponse = response;
	$responseXML = $.parseXML(response);
	if(parentId=='addClient')
	{
		
		$($.parseXML(response)).find("ClientDetailVO").each(function(){
			var respRow='<tr>'+
				'<td class="ClientName">'+$(this).find('LastName').text()+', '+ $(this).find('FirstName').text()+
			'</td><td class="TaxIdentification">'+$(this).find('TaxIdentification').text()+
			'</td><td class="ClientStatus">'+$(this).find('StatusCT').text()+
			'</td><td class="DateOfBirth">'+$(this).find('BirthDate').text()+
			'</td><td class="ClientDetailPK" style="display:none;">'+$(this).find('ClientDetailPK').text()+'</td>';
			$('#clientSearchResult > tbody:last').append(respRow);
		});
	} else {
		$($.parseXML(response)).find("SearchResponseVO").each(function(){
			var respRow='<tr><td class="ClientName">'+$(this).find('ClientName').text()+
							'</td><td class="TaxIdentification">'+$(this).find('TaxIdentification').text()+
							'</td><td class="ClientStatus">'+$(this).find('ClientStatus').text()+'</td><td class="searchData" style="display:none;">'+this+'</td>';
							
			$('#clientSearchResult > tbody:last').append(respRow);
		});
	}
}

function clearClientSearchTable()
{
	$('#clientSearchResult > tbody > tr').each(function() {
		$(this).remove();
	});
}

function clearClientSearchBox()
{
	$('#searchClientName').val('');
	$('#searchPolicyNumber').val('');
	$('#searchTaxId').val('');
	
	clearClientSearchTable();
}

function disableSearchFields(field)
{
	$('.clientSearchInputField')
		.not($(field))
		.prop('disabled', true);
}