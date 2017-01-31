 /* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function getXMLHttpRequest() {
  var xmlHttpReq = false;
  // to create XMLHttpRequest object in non-Microsoft browsers
  if (window.XMLHttpRequest) {
    xmlHttpReq = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    try {
      // to create XMLHttpRequest object in later versions
      // of Internet Explorer
      xmlHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (exp1) {
      try {
        // to create XMLHttpRequest object in older versions
        // of Internet Explorer
        xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (exp2) {
        xmlHttpReq = false;
      }
    }
  }
  return xmlHttpReq;
}

 function readyStateHandlerText(req,responseTextHandler){
       return function() {
                if (req.readyState == 4) {
            if (req.status == 200) {
                  responseTextHandler(req.responseXML);
            } else {
                alert("HTTP error"+req.status+" : "+req.statusText);
            }
        }
       
    }
} 

/**
 * For doc Ajax call
 * 
 */
function getlfcPODetails(number,id,type){
    var num=number;
    var id=id;
    var type = type;
    $(function() {
       
           $('#detail_box').show();
           return false;
               
   });
   // alert("in js--->"+num+"-----"+type);
   var req = getXMLHttpRequest();
   req.onreadystatechange = readyStateHandlerText(req,populateLifecycle); 
   var url="../ajax/LifecycleDetails.action?poNumber="+num+"&fileId="+id+"&type="+type;
   req.open("GET",url,"true");
   // req.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    req.send(null);
}



function populateLifecycle(responseXML)
{
    var details = responseXML.getElementsByTagName("DETAILS")[0];
    var detail = details.childNodes[0];
    var chk=detail.getElementsByTagName("VALID")[0];  
    
     if(chk.childNodes[0].nodeValue =="true") {
    
            var detail = details.childNodes[0];
            var fileid = detail.getElementsByTagName("FILEID")[0].childNodes[0].nodeValue;   
            var PRE_TRANS_FILEPATH = detail.getElementsByTagName("PRETRANSFILEPATH")[0].childNodes[0].nodeValue;
            var POST_TRANS_FILEPATH = detail.getElementsByTagName("PRETRANSFILEPATH")[0].childNodes[0].nodeValue; 
             var ACKFILEID = detail.getElementsByTagName("ACKFILE")[0].childNodes[0].nodeValue; 
            var SENDER_ID = detail.getElementsByTagName("SENDER_ID")[0].childNodes[0].nodeValue;
            var RECEIVER_ID = detail.getElementsByTagName("RECEIVER_ID")[0].childNodes[0].nodeValue;
            
            var SENDER_NAME = detail.getElementsByTagName("SENDER_NAME")[0].childNodes[0].nodeValue;
            var RECEIVER_NAME = detail.getElementsByTagName("RECEIVER_NAME")[0].childNodes[0].nodeValue;
            
            var STATUS = detail.getElementsByTagName("STATUS")[0].childNodes[0].nodeValue; 
           var PO_NUMBER = detail.getElementsByTagName("PO_NUMBER")[0].childNodes[0].nodeValue; 
            var PO_DATE = detail.getElementsByTagName("PO_DATE")[0].childNodes[0].nodeValue;
            var PO_STATUS = detail.getElementsByTagName("PO_STATUS")[0].childNodes[0].nodeValue;
            var SO_NUMBER = detail.getElementsByTagName("SO_NUMBER")[0].childNodes[0].nodeValue;
            var ITEM_QTY = detail.getElementsByTagName("ITEM_QTY")[0].childNodes[0].nodeValue;
            
            var ISA_NUMBER = detail.getElementsByTagName("ISA_NUMBER")[0].childNodes[0].nodeValue;
            var ISA_DATE = detail.getElementsByTagName("ISA_DATE")[0].childNodes[0].nodeValue;
            var ISA_TIME = detail.getElementsByTagName("ISA_TIME")[0].childNodes[0].nodeValue;
             var TRANS_TYPE = detail.getElementsByTagName("TRANS_TYPE")[0].childNodes[0].nodeValue;
        document.getElementById('LfcInstanceId').value=fileid;
        if(PO_NUMBER != "NO"){
            document.getElementById('LfcPONum').value=PO_NUMBER;
        }
        else
        {
            document.getElementById('LfcPONum').value="--";
        }
        if(PO_DATE != "NO"){
            document.getElementById('LfcPODates').value=PO_DATE;
        }
        else
        {
            document.getElementById('LfcPODates').value="--";
        }
        if(PO_STATUS != "NO"){
            document.getElementById('LfcStatus1').value=PO_STATUS;
        }    
        else{
            document.getElementById('LfcStatus1').value="--";
        }
        if(SO_NUMBER != "NO"){
            document.getElementById('LfcSo').value=SO_NUMBER;
        }  
        else{
            document.getElementById('LfcSo').value="--";
        }
        if(ITEM_QTY  != "NO"){
            document.getElementById('LfcPOQty').value=ITEM_QTY ;
        }
        else
        {
            document.getElementById('LfcPOQty').value="--";
        }
                if(TRANS_TYPE != "NO"){
                     document.getElementById('LfcTransactionType').value=TRANS_TYPE;
                }
                else
                {
                     document.getElementById('LfcTransactionType').value="--";
                }
         document.getElementById('LycPOPartnerId').value=SENDER_ID;
        document.getElementById('LycPOPartnerName').value=SENDER_NAME;
        document.getElementById('LfcPOReceiverId').value=RECEIVER_ID;
        document.getElementById('LfcPOReceiverName').value=RECEIVER_NAME;       
        if(ISA_NUMBER != 0){
            document.getElementById('LfcPOIsa').value=ISA_NUMBER;
        }
        else{
            document.getElementById('LfcPOIsa').value="--";
        }
        if(ISA_DATE != null){
            document.getElementById('LfcPOISADate').value=ISA_DATE;
    }
        else{
            document.getElementById('LfcPOISADate').value="--";
        }
        if(ISA_TIME != 0){
            document.getElementById('LfcPOIsATime').value=ISA_TIME;
        }
        else
        {
            document.getElementById('LfcPOIsATime').value="--";
        }
        
        if(STATUS.toUpperCase() == "ERROR"){
            document.getElementById('LfcPOStatus').value=STATUS;
        }else if(STATUS.toUpperCase() == "SUCCESS"){
            document.getElementById('LfcPOStatus').value=STATUS;
        }else {
            document.getElementById('LfcPOStatus').value=STATUS;
        }
       
        if(PRE_TRANS_FILEPATH == "No File"){
            document.getElementById('LfcPOPreTransition').innerHTML="--";
        }else{
            document.getElementById('LfcPOPreTransition').innerHTML="<a href=\"../download/getAttachment.action?locationAvailable="+PRE_TRANS_FILEPATH+"\">Download</a>";
        }
        if(POST_TRANS_FILEPATH == "No File"){
            document.getElementById('LfcPOPostTransition').innerHTML="--";
         
        }else{
            document.getElementById('LfcPOPostTransition').innerHTML="<a href=\"../download/getAttachment.action?locationAvailable="+POST_TRANS_FILEPATH+"\">Download</a>";
        }
        if(ACKFILEID == "No File"){
            document.getElementById('LfcPOAckFileId').innerHTML="--";
        }else{
            document.getElementById('LfcPOAckFileId').innerHTML="<a href=\"../download/getAttachment.action?locationAvailable="+ACKFILEID+"\">Download</a>";
        }
       
       // this value is not coming so skipped to show detail Info. Please check in XML response and check the ID of error msg.
       
//       if(ERRMESSAGE != "NO MSG"){
//            document.getElementById('InvErrormessage').innerHTML=ERRMESSAGE;
//               
//        }
    }
    if(chk.childNodes[0].nodeValue =="false") {
        document.getElementById('noresult').value=" <h5 >Sorry ! No Results Found</h5>";
      
                    
    }
     
    $('#hide-menu1').addClass('show-menu');
 
 
}

