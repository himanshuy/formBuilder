<!--
 ** @Author: Himanshu Yadav
 -->
<!DOCTYPE html>
<html lang="en">
<#import "spring.ftl" as spring />
<#import "customFields.ftl" as customFields />
	<head>
		<title>Application Entry</title>
		<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
		<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-multiselect.css"/>
		<link rel="stylesheet" type="text/css" href="resources/css/font-awesome.css"/>
		<link rel="stylesheet" type="text/css" href="resources/css/poc.css"/>
		<link rel="stylesheet" href="resources/css/jquery-ui.css" />
		<script src="resources/js/jquery.js"></script>
		<script src="resources/js/jquery-ui.js"></script>
  		
  		<script>
  			/*(function () {
			    var timeoutSession;
			    document.addEventListener('mousemove', function (e) {
			        clearTimeout(timeoutSession);
			        timeoutSession = setTimeout(function () {
			            $('#timeoutModal').modal('show');
			            //call the server to save the data
			        },3000); //30s
			    }, true);
			})();*/
			
			$(function () {
				$('.datePicker').each(function(i, obj){
					$(obj).datepicker();
				});
			});
			var sectionArray;
			var parentId; //It is only added for Policy Save 
			
			$(document).ready(function(){
				 $('.multiselect').multiselect({
			        	includeSelectAllOption: true
			      });
				jQuery.event.props.push('dataTransfer');
				$('#drop-files').bind('drop', function(e) {
					var files = e.dataTransfer.files;
					$.each(files, function(index, file) {
						if(file.type=='text/xml')
						{
							$('#uploadError').show();
						} else {
							$('#uploadError').hide();
							$('#uploadDocs').append('<li><a href="#">'+file.name+'<button type="button" class="close" aria-hidden="true">&times;</button></li>');
						}
						
					});
					return false;
				});
				$('[data-toggle=offcanvas]').click(function() {
				    $('.row-offcanvas').toggleClass('active');
				 });
				$('.close').click(function() {
				    $(this).closest('li').remove();
				});
			    if($('form').attr('type')=='wizard')
			    {
			    	var sectionArray = new Array()
			    	$('.section').each(function(i, section){
			    		sectionArray[i]= section;
			    		if(i!=0) {
			    			$(section).hide();
			    		}
			    		
			    	});
			    	$('#navButtons').show();
			    	$('#prev').attr('disabled','disabled');
			    } else {
			    	$('#submitButtons').show();
			    	
			    }
			    $('#addClient').click(function() {
			    	parentId='addClient';
			    	clearClientSearchBox();
			    	$('#clientSearchModal').modal('toggle');
                	$('.clientSearchInputField').prop('disabled',false);
			    });
			    $('#navButtons > button').click(function(){
			    	var clickedButton = this;
			    	var numberOfSections = $('.section').length;
			    	$('.section').each(function(i, section){
			    		if($(clickedButton).attr('id')=='next' && i==numberOfSections-2)
			    		{
			    			$('#navButtons').hide();
			    			$('#submitButtons').show();
			    		}
		    			$('#prev').removeAttr('disabled');
			    		var booleanKeepGoing = true;
			    		if($(section).is(':visible'))
			    		{
			    			$(section).hide();
			    			if($(clickedButton).attr('id')=='next')
			    			{
			    				//lastSectionIsVisible(sectionArray[i+1]);
			    				$(sectionArray[i+1]).show();
			    				
			    			} 
			    			else if($(clickedButton).attr('id')=='prev') 
			    			{
			    				$(sectionArray[i-1]).show();
			    			}
			    			
			    			booleanKeepGoing = false;
			    		}
			    		return booleanKeepGoing;
			    	});
			    });
				
				$('form').submit(function () {
					//validateRequiredFields();
					//collectFormData();
                    $.ajax({
                        url: $(this).attr('action'),
                        type: 'POST',
                        processData: false,
                        data: collectFormData(),
                        //data:encodeURIComponent(requestForClientSearch()),
                        headers: {
                            "Content-Type":"application/xml"
                        },
                        success: function (data) {
                        	var message= $(data).find('Message').text();
                        	$('#contractSave').append(message).show();
                            //$('#successSection').show();
                            //$('.successMsg').text(data)
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.log('jqXHR:'+jqXHR+'/n'+
                            			'textStatus:'+textStatus+'/n'+
                            			'errorThrown::'+errorThrown);
                        }
                    });

                    return false;
                });
                
                $('#saveWithoutValidation').click(function(){
                	//alert($.parseXML(collectFormData()));
                	loadFormData();
                });
                
                $('.badge').click(function(){
                	//alert($(this).prev().val());
                	if($(this).prev().val()!='')
                	{
                		validateWithPRASE($(this).prev());
                	}
                });
                
                $('.searchImg').click(function() {
                	clearClientSearchBox();
                	$('#parentSectionOfClientSearch').text($(this).parent().parent().parent().attr("name"));
                	$('#clientSearchModal').modal('toggle');
                	$('.clientSearchInputField').prop('disabled',false);
                	
                });
                
                $('.clientSearchInputField').keyup(function() {
                	if($(this).val()!='')
                	{
						disableSearchFields(this);
	                	if(parentId='addClient') {
	                		var requestXML = requestClientSearchForPolicySave();
	                	} else {
	                		var requestXML = requestForClientSearch();
	                	}
	                	
	                	console.log(requestXML);
	                	$('.loadingImage').show();
	                	$.ajax({
	                		type:"POST",
	                		url:"searchForClient",
	                		data:(new XMLSerializer()).serializeToString(requestXML),
	                		headers: {
	                            "Content-Type":"application/xml"
	                        },
	                		success: function(response) {
	                			clearClientSearchTable();
	                			parseClientSearchResponse(response);
	                			$('.loadingImage').hide();
	                		},
	                		error:function (xhRequest, ErrorText, thrownError) {
	            				alert('Error: '  + '  ' + xhRequest);
	            			}
	                	});
                                	
                	 }
                	});
                
                $("#clientSearchResult").delegate("tr", "click", function(){
                		populateClientSection(this);
                	$('#clientSearchModal').modal('toggle');
			    });
			    
			    $('input.amount').keyup(function(event) {

				  // skip for arrow keys
				  if(event.which >= 37 && event.which <= 40){
				    event.preventDefault();
				  }
				 if($('.amount')){
					 $(this).val(function(index, value) {
					    return value
					      .replace(/\D/g, "")
					      .replace(/([0-9])([0-9]{2})$/, '$1.$2')  
					      .replace(/\B(?=(\d{3})+(?!\d)\.?)/g, ",")
					    ;
					});
				 } 
				});
			});
			
  		</script>
	</head>
 <body style>
 	<div class="navbar navbar-fixed-top navbar-inverse" role="navigation" id="navbar">
      <div class="container">
        <div class="navbar-header" >
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <p class="navbar-brand" style="color:#ffffff;">Product:True Term, IL</p>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
          </ul>
        </div><!-- /.nav-collapse -->
      </div><!-- /.container -->
    </div>
	<div class="container">
		<div class="row row-offcanvas row-offcanvas-right">
		<div class="col-xs-12 col-sm-9">
	<#assign header=doc.applicationEntry.header >
	<div class="row">
		<div class="col-sm-6"><img style="padding:15px;" src="resources/img/gerber_logo.png"/></div>
  		<div class="col-sm-6">
  		 <ul class="list-unstyled pull-right">
  			<li><h2>${header.formName}</h2></li>
			<li><h5>${header.description}</h5></li>
		 </ul>
		</div>
	</div>
	
    <form method="POST" action="savePolicy" class="" name="${doc.applicationEntry.@name}" type=${doc.applicationEntry.@type} enctype="multipart/form-data">
    <div style="display:none;" id="parentSectionOfClientSearch"></div>
    <#if errorMap??>
    	<#assign sectionsWithError = errorMap?keys>
		<div class="alert alert-block alert-danger fade in">
        	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        	<h4>Oh snap! You got an error.</h4>
        	<#list sectionsWithError as sectionWithError>
	    		<p>Section <strong>${sectionWithError}</strong> has following mismatched fields:</p>
		    		<ul>
		    		<#list errorMap[sectionWithError] as field>
		    			<li>${field}</li>
		    		</#list> 
		    		</ul>
	    	</#list>
        </div>
    </#if>
    <div style="display:none;" class="alert alert-success"id="contractSave"><strong>Well Done! </strong></div>
	<#list doc.applicationEntry.section as section>
	<div class="section" name="${section.@name}" id="${section.@name}">
	<div class="row field sectionTitle">
		<div class="col-md-6" >
		<#assign sectionName=section.@name>
			<#if section.@label[0]??>
		 		<span class="section-title">${section.@label} </span>
		 	</#if>
		 	<#if sectionName=='ClientInformation'>
		 		<img src="resources/img/search.png" class="searchImg col-xs-offset-6 col-sm-offset-5 col-md-offset-6" id="searchClient"/>
		 	</#if>
		</div>
	 </div>
	 	<#if section.@type[0]?? && section.@type=='questionnaire'>
	 		<#list section.field as field>
	 			<#if field.@type=="question">
	 				<div class="row row-padded" id="${field.@name}">
	 					<strong>Question: </strong><p>${field.@label}</p>
					 	<strong>Answer:</strong>
					 	<#if field.@answerType="yes/no">
						 	<div class="radio-inline">
							  <label><input type="radio" name=${field.@name} id="optionsRadios1" value="Yes"
							  	<#if field.@hasChildren[0]?? && field.@hasChildren=='yes'>
							  		onClick=showChildFields(this,"${field.@childFields?js_string}")
							  	</#if>
							  >Yes</label>
							</div>
							<div class="radio-inline">
							  <label><input type="radio" name=${field.@name} id="optionsRadios2" value="No"
							  	<#if field.@hasChildren[0]?? && field.@hasChildren=='yes'>
							  		onClick=showChildFields(this,"${field.@childFields?js_string}")
							  	</#if>
							  >No</label>
							</div>
						<#elseif field.@answerType="codeTable">
							<div class="radio-inline">
								<#assign codeTableList = codeTableWrapper.getCodeTableEntries(field.@codeTableName,0)/>
						    	<span>Select a value </span><select name="${field.@name}" onChange=showChildFields(this,"${field.@childFields?js_string}");>
						    		<#list codeTableList as codeTable>
						    			<option value="${codeTable.code}">${codeTable.codeDesc}</option>
						    		</#list>
						    	</select>
							</div>
						</#if>
						<#if field.@hasChildren[0]?? && field.@hasChildren=='yes' >
							<div class="row childFields" id=parent-${field.@name} style="display:none">
    						<p class="subtitle">Give full details here: </p>
	    						<#list field.field as childField>
	    							<div class="col-md-6 colChildFields" style="display:none" name="${childField.@name}">
								      <@customFields.createFieldLabel field=childField/>
									  	<#if childField.@type == "text">
									  		<@customFields.createTextfield field=childField />
									  	<#elseif childField.@type == "date">
									  		<@customFields.createdatefield field=childField />
									  	
									  	<#elseif childField.@type == "select">
									  		<@customFields.createCodeTableField field=field/>
									  	<#else>
									  		<@customFields.createSpecialTextField field=childField/>
									  	</#if>
								    </div>
	    						</#list>
							</div>
						</#if>
	 				</div>
				</#if>
	 		</#list>
	 	<#else>
			<!-- <#list section.field?chunk(2) as row>
			 <div class="row field">
			  <#list row as field>
				  <@customFields.createField field=field/>
			  </#list>
			 </div>
			</#list> -->
			<!--<#assign row=[]/>
			<#assign sizeOfSection=section.field?size>
			<#list section.field as field>
				<#if field.@type=="note">
				 <div class="row field">
				 	<@customFields.createNoteField field=field/>
				 </div>
				<#else>
					<#assign row=row+[field]/>
					<#if row?size == 2>
						<div class="row field">
						  <#list row as row_field>
							  <@customFields.createField field=row_field/>
						  </#list>
						 </div>
						<#assign row=[]/>
					<#elseif row?size == 1 && field_index==sizeOfSection-1>
						<div class="row field">
						  <#list row as row_field>
							  <@customFields.createField field=row_field/>
						  </#list>
						 </div>
						<#assign row=[]/>			 
					</#if>
				</#if>
			</#list> -->
			
			<#assign fields=section.field/>
			<@customFields.columnate fields=fields/>
			
		</#if>
		
	  </div>
	  </#list>
	  <!--Static Question section starts here -->
	  <!--Static Question section Ends here -->
	  <div class="row pull-right" id="submitButtons" style="display:none;">
	  	<input class="btnnew" type="button"  id="saveWithoutValidation" value="Save Without Validation"></input>
	  	<input type="submit" class="btnnew" name="action" formnovalidate  value="Submit"></input>
	  </div>
	  <div class="row pull-right" id="navButtons" style="display:none;">
	  	<button type="button" class="btn btn-info navButton" id="prev">Previous</button>
	  	<button type="button" class="btn btn-info navButton" id="next">Next</button>
	  </div>
	  <br/>
	</div>  
	</form>
	<div class="col-xs-6 col-sm-3 sidebar-offcanvas sidebar-nav-fixed uploadSideBar"  role="navigation">
		
          <div class="well sidebar-nav" id="sidebar">
          
          <div id="drop-files" ondragover="return false">
				<span>Drop Document Here</span><br/>
				<i class="icon-cloud-upload icon-4x"></i>
			</div>
			<div class="alert alert-danger alert-dismissable" id="uploadError" style="display:none">
			  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			  <strong>Oh snap!</strong> XML documents are not allowed here.
			</div>
            <ul class="list-unstyled" id="uploadDocs">
              <li>Available Documents</li>
              <li><a href="#">Birth_Certificate.pdf</a> <button type="button" class="close" aria-hidden="true">&times;</button></li>
              <li><a href="#">Drivers_License.pdf</a> <button type="button" class="close" aria-hidden="true">&times;</button></li>
              <li><a href="#">Medical_Details.doc</a> <button type="button" class="close" aria-hidden="true">&times;</button></li>
            </ul>
          </div><!--/.well -->
        </div>
        
	</div>
	
	</div>
	
	<div class="modal fade" id="timeoutModal">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h4 class="modal-title">Session Timed Out</h4>
	      </div>
	      <div class="modal-body">
	        <p>Your session has been timed out but we have saved your work. Please continue from where you left.</p>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<div class="modal fade" id="clientSearchModal">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header" id="praseErrorHeader">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h4 class="modal-title">Client Search</h4>
	      </div>
	      <div class="modal-body">
	      	<div class="form-inline">
	      		<input type="text" class="clientSearchInputField" id="searchClientName" placeholder="Client Name">
	      		<input type="text" class="clientSearchInputField" id="searchPolicyNumber" placeholder="Policy Number">
	      		<input type="text" class="clientSearchInputField" id="searchTaxId" placeholder="Tax ID">
	      	</div>
	      	<div class="loadingImage" style="display:none;">
	      		<img src="resources/img/ajax-loader.gif"/>
	      	</div>
	      </div>
	      <div class="modal-footer">
	      	<table class="table table-hover table-bordered" id="clientSearchResult">
	      		<thead>
	      			<tr>
	      				<th>Name</th>
	      				<th>Tax Id</th>
	      				<th>Status</th>
	      				<th>DOB</th>
	      			</tr>
	      		</thead>
	      		<tbody>
	      		</tbody>
	      	</table>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<!-- <div id="praseErrorModal" class="modal hide fade">
	  <div id="praseErrorModalHeader" class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	    <h3>Prase Error</h3>
	  </div>
	  <div class="modal-body">
	    
	  </div>
	  <div class="modal-footer">
	    <a href="#" class="btn" data-dismiss="modal">Fix it</a>
	  </div>
	</div> -->
		<script src="resources/js/bootstrap.js"></script>
  		<script src="resources/js/bootstrap-tooltip.js"></script>
  		<script src="resources/js/bootstrap-popover.js"></script>
  		<script src="resources/js/bootstrap-multiselect.js"></script>
  		<script src="resources/js/appEntry.js"></script>
  		<script src="resources/js/clientSection.js"></script>
 </body>
</html>