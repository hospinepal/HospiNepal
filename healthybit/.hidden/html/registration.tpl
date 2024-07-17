<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>

<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<title>label</title>
<style>
body
{
font-family: "Comic Sans MS",sans-serif;
letter-spacing: 1px;
font-size: 12px;
text-transform: uppercase;
line-height: 1.2;
}
.barcode
{
width: 80px; 
height: 80px;
}
table
{
text-align: left; width: 100%;
}
table td
{
text-align: left; 
}
</style>
</head>
<body>
<table class='header_table' border="0" cellpadding="2" cellspacing="0" id="headtable">
	<tr>   
			<td colspan="1" rowspan="4" style="width: 50%;">
			CODE : {PatientCode}
			<br>
			CLAIM CODE: {LastClaimCode}
			<br>
			PATIENT NO : <b>{PatientNo}</b>
			<br>
			ENCID : <b><span style="font-size:16px;" > {Encounter}<span></b>
		</td>
		<td >
			<img class="barcode" src=$BarCode[{PatientNo}]>
		</td>
		
	</tr>
</table>	
<table>
	<tr>
		<td colspan="2">
			Department :<span style="font-size:14px;font-weight:bold" >{LastVisitLocation}</span>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			NAME : <span style="font-size:14px;font-weight:bold">{PatientName}</span>
		</td>
	</tr>
	<tr>
		<td style="width:35%">
			AGE/SEX : {Age/Sex}			
		</td>
				<td>
			कोठा नं :  <span style="font-size:16px;font-weight:bold"> {LastConsultRoom}</span>			
		</td>
	</tr>
	<tr>
		<td colspan="2">
			ADDRESS : {PatientAddress}			
		</td>
	</tr>
	<tr>
		<td style="width:60%">
			VISIT DATE : {LastVisitDate} {LastVisitTime}			
		</td>
		<td>
			USER : {CurrentUser}			
		</td>
	</tr>
</table>
</body>
</html>

