<table class='header_table' style="text-align: left; width: 100%;letter-spacing: 1px;font-size: 13px;text-transform: uppercase;line-height: 1.5;border-bottom:1px solid;" border="0" cellpadding="2" cellspacing="0" id="headtable">
  <tbody>

 <tr>
     <td style="vertical-align: top;font-weight:bold;width:22%">Invoice No </td>
      <td colspan="2" style="vertical-align: top;font-weight:bold;">: {InvoiceNumber}</td>  
 </tr>

  <tr>
    <td style="vertical-align: top; width: 22%;">Trans. Date</td>
    <td colspan ="2"style="vertical-align: top;font-weight:bold;">: {BillDateTime}</td>    
  </tr>

  <tr>
     <td style="vertical-align: top; width: 22%;">Enc No.</td>
      <td colspan="2" style="vertical-align: top;font-weight:bold;">: {Encounter}</td>
   </tr>
   
   <tr>
     <td style="vertical-align: top;width:22%">NAME</td>
     <td colspan="2"style="vertical-align: top;font-weight:bold;"><span style="text-transform:uppercase;">: {PatientName}<span></td>
   </tr>
  
  <tr>
      <td style="vertical-align: top;width:22%">Age/Sex</td>
      <td colspan="2" style="vertical-align: top;">: {Age/Sex}</td>
    </tr>
   
   <tr>
      <td style="vertical-align: top;width:22%">Address</td>
      <td colspan:"2" style="vertical-align: top;">: {PatientAddress}</td>
    </tr>
   
   <tr>
      <td style="vertical-align: top;width:22%;">Claim Code</td>
      <td colspan="2" style="vertical-align: top;">: {InvRefNumber}</td>
      <td style="vertical-align: top; width :20%">PAN/NHIS:{PatientCode}</td>
    </tr>
      
    <tr>
      <td style="vertical-align: top;width:22%;">Account </td>
       <td colspan="2" style="vertical-align: top;font-weight:bold;">: {LedgerA/C} </td>
       <td style="vertical-align: top; width :20%">Mode: {InvoiceMode}</td>
    </tr>
    
    <tr>
      <td style="vertical-align: top;width:22%;">QR Payment </td>
      <td colspan="2" style="vertical-align: top;">: {QRPayment}  {CashSource}</td>
      <td style="vertical-align: top; width :20%">Status:{InvPatStatus}</td>    
    </tr>

  </tbody>
</table>
