//
// Vivado(TM)
// rundef.js: a Vivado-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
  PathVal = "E:/Vivado/Vitis/2020.1/bin;E:/Vivado/Vivado/2020.1/ids_lite/ISE/bin/nt64;E:/Vivado/Vivado/2020.1/ids_lite/ISE/lib/nt64;E:/Vivado/Vivado/2020.1/bin;";
} else {
  PathVal = "E:/Vivado/Vitis/2020.1/bin;E:/Vivado/Vivado/2020.1/ids_lite/ISE/bin/nt64;E:/Vivado/Vivado/2020.1/ids_lite/ISE/lib/nt64;E:/Vivado/Vivado/2020.1/bin;" + PathVal;
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


ISEStep( "vivado",
         "-log u2r_cmd_fifo.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source u2r_cmd_fifo.tcl" );



function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
