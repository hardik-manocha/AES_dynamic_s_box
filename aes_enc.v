module aes_enc ( input clk,rst,
                  input [0:127]data_in,key_in,
                  output reg [0:127]data_out,
						//output reg [0:3]key_no,
						output reg [0:127]key_out,
						output reg [0:3]key_store_no,
						output reg [0:7]dynamic_s_box_reg
                );

reg [0:6]enc_state;
reg [0:31]state0,state1,state2,state3;
reg [0:31]aes_matrix0_step1,aes_matrix1_step1,aes_matrix2_step1,aes_matrix3_step1;

reg b;
reg [0:127]op_reg;

//wire [0:127]key_out;
reg rst_key_schedule;
reg [0:127]key_in_key_schedule;
reg [0:3]round_no_key_schedule;
wire [0:127]key_out_key_schedule;

parameter [0:127]subbyte0=128'h637c777bf26b6fc53001672bfed7ab76;
parameter [0:127]subbyte1=128'hca82c97dfa5947f0add4a2af9ca472c0;
parameter [0:127]subbyte2=128'hb7fd9326363ff7cc34a5e5f171d83115;
parameter [0:127]subbyte3=128'h04c723c31896059a071280e2eb27b275;
parameter [0:127]subbyte4=128'h09832c1a1b6e5aa0523bd6b329e32f84;
parameter [0:127]subbyte5=128'h53d100ed20fcb15b6acbbe394a4c58cf;
parameter [0:127]subbyte6=128'hd0efaafb434d338545f9027f503c9fa8;
parameter [0:127]subbyte7=128'h51a3408f929d38f5bcb6da2110fff3d2;
parameter [0:127]subbyte8=128'hcd0c13ec5f974417c4a77e3d645d1973;
parameter [0:127]subbyte9=128'h60814fdc222a908846eeb814de5e0bdb;
parameter [0:127]subbytea=128'he0323a0a4906245cc2d3ac629195e479;
parameter [0:127]subbyteb=128'he7c8376d8dd54ea96c56f4ea657aae08;
parameter [0:127]subbytec=128'hba78252e1ca6b4c6e8dd741f4bbd8b8a;
parameter [0:127]subbyted=128'h703eb5664803f60e613557b986c11d9e;
parameter [0:127]subbytee=128'he1f8981169d98e949b1e87e9ce5528df;
parameter [0:127]subbytef=128'h8ca1890dbfe6426841992d0fb054bb16;

reg [0:127]d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef;

function [0:127]dynamic_s_box_0;
	input [0:7]keyi;
	begin
		dynamic_s_box_0[0:7]=subbyte0[0:7] ^ keyi;
		dynamic_s_box_0[8:15]=subbyte0[8:15] ^ keyi;
		dynamic_s_box_0[16:23]=subbyte0[16:23] ^ keyi;
		dynamic_s_box_0[24:31]=subbyte0[24:31] ^ keyi;
		dynamic_s_box_0[32:39]=subbyte0[32:39] ^ keyi;
		dynamic_s_box_0[40:47]=subbyte0[40:47] ^ keyi;
		dynamic_s_box_0[48:55]=subbyte0[48:55] ^ keyi;
		dynamic_s_box_0[56:63]=subbyte0[56:63] ^ keyi;
		dynamic_s_box_0[64:71]=subbyte0[64:71] ^ keyi;
		dynamic_s_box_0[72:79]=subbyte0[72:79] ^ keyi;
		dynamic_s_box_0[80:87]=subbyte0[80:87] ^ keyi;
		dynamic_s_box_0[88:95]=subbyte0[88:95] ^ keyi;
		dynamic_s_box_0[96:103]=subbyte0[96:103] ^ keyi;
		dynamic_s_box_0[104:111]=subbyte0[104:111] ^ keyi;
		dynamic_s_box_0[112:119]=subbyte0[112:119] ^ keyi;
		dynamic_s_box_0[120:127]=subbyte0[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_1;
	input [0:7]keyi;
	begin
		dynamic_s_box_1[0:7]=subbyte1[0:7] ^ keyi;
		dynamic_s_box_1[8:15]=subbyte1[8:15] ^ keyi;
		dynamic_s_box_1[16:23]=subbyte1[16:23] ^ keyi;
		dynamic_s_box_1[24:31]=subbyte1[24:31] ^ keyi;
		dynamic_s_box_1[32:39]=subbyte1[32:39] ^ keyi;
		dynamic_s_box_1[40:47]=subbyte1[40:47] ^ keyi;
		dynamic_s_box_1[48:55]=subbyte1[48:55] ^ keyi;
		dynamic_s_box_1[56:63]=subbyte1[56:63] ^ keyi;
		dynamic_s_box_1[64:71]=subbyte1[64:71] ^ keyi;
		dynamic_s_box_1[72:79]=subbyte1[72:79] ^ keyi;
		dynamic_s_box_1[80:87]=subbyte1[80:87] ^ keyi;
		dynamic_s_box_1[88:95]=subbyte1[88:95] ^ keyi;
		dynamic_s_box_1[96:103]=subbyte1[96:103] ^ keyi;
		dynamic_s_box_1[104:111]=subbyte1[104:111] ^ keyi;
		dynamic_s_box_1[112:119]=subbyte1[112:119] ^ keyi;
		dynamic_s_box_1[120:127]=subbyte1[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_2;
	input [0:7]keyi;
	begin
		dynamic_s_box_2[0:7]=subbyte2[0:7] ^ keyi;
		dynamic_s_box_2[8:15]=subbyte2[8:15] ^ keyi;
		dynamic_s_box_2[16:23]=subbyte2[16:23] ^ keyi;
		dynamic_s_box_2[24:31]=subbyte2[24:31] ^ keyi;
		dynamic_s_box_2[32:39]=subbyte2[32:39] ^ keyi;
		dynamic_s_box_2[40:47]=subbyte2[40:47] ^ keyi;
		dynamic_s_box_2[48:55]=subbyte2[48:55] ^ keyi;
		dynamic_s_box_2[56:63]=subbyte2[56:63] ^ keyi;
		dynamic_s_box_2[64:71]=subbyte2[64:71] ^ keyi;
		dynamic_s_box_2[72:79]=subbyte2[72:79] ^ keyi;
		dynamic_s_box_2[80:87]=subbyte2[80:87] ^ keyi;
		dynamic_s_box_2[88:95]=subbyte2[88:95] ^ keyi;
		dynamic_s_box_2[96:103]=subbyte2[96:103] ^ keyi;
		dynamic_s_box_2[104:111]=subbyte2[104:111] ^ keyi;
		dynamic_s_box_2[112:119]=subbyte2[112:119] ^ keyi;
		dynamic_s_box_2[120:127]=subbyte2[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_3;
	input [0:7]keyi;
	begin
		dynamic_s_box_3[0:7]=subbyte3[0:7] ^ keyi;
		dynamic_s_box_3[8:15]=subbyte3[8:15] ^ keyi;
		dynamic_s_box_3[16:23]=subbyte3[16:23] ^ keyi;
		dynamic_s_box_3[24:31]=subbyte3[24:31] ^ keyi;
		dynamic_s_box_3[32:39]=subbyte3[32:39] ^ keyi;
		dynamic_s_box_3[40:47]=subbyte3[40:47] ^ keyi;
		dynamic_s_box_3[48:55]=subbyte3[48:55] ^ keyi;
		dynamic_s_box_3[56:63]=subbyte3[56:63] ^ keyi;
		dynamic_s_box_3[64:71]=subbyte3[64:71] ^ keyi;
		dynamic_s_box_3[72:79]=subbyte3[72:79] ^ keyi;
		dynamic_s_box_3[80:87]=subbyte3[80:87] ^ keyi;
		dynamic_s_box_3[88:95]=subbyte3[88:95] ^ keyi;
		dynamic_s_box_3[96:103]=subbyte3[96:103] ^ keyi;
		dynamic_s_box_3[104:111]=subbyte3[104:111] ^ keyi;
		dynamic_s_box_3[112:119]=subbyte3[112:119] ^ keyi;
		dynamic_s_box_3[120:127]=subbyte3[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_4;
	input [0:7]keyi;
	begin
		dynamic_s_box_4[0:7]=subbyte4[0:7] ^ keyi;
		dynamic_s_box_4[8:15]=subbyte4[8:15] ^ keyi;
		dynamic_s_box_4[16:23]=subbyte4[16:23] ^ keyi;
		dynamic_s_box_4[24:31]=subbyte4[24:31] ^ keyi;
		dynamic_s_box_4[32:39]=subbyte4[32:39] ^ keyi;
		dynamic_s_box_4[40:47]=subbyte4[40:47] ^ keyi;
		dynamic_s_box_4[48:55]=subbyte4[48:55] ^ keyi;
		dynamic_s_box_4[56:63]=subbyte4[56:63] ^ keyi;
		dynamic_s_box_4[64:71]=subbyte4[64:71] ^ keyi;
		dynamic_s_box_4[72:79]=subbyte4[72:79] ^ keyi;
		dynamic_s_box_4[80:87]=subbyte4[80:87] ^ keyi;
		dynamic_s_box_4[88:95]=subbyte4[88:95] ^ keyi;
		dynamic_s_box_4[96:103]=subbyte4[96:103] ^ keyi;
		dynamic_s_box_4[104:111]=subbyte4[104:111] ^ keyi;
		dynamic_s_box_4[112:119]=subbyte4[112:119] ^ keyi;
		dynamic_s_box_4[120:127]=subbyte4[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_5;
	input [0:7]keyi;
	begin
		dynamic_s_box_5[0:7]=subbyte5[0:7] ^ keyi;
		dynamic_s_box_5[8:15]=subbyte5[8:15] ^ keyi;
		dynamic_s_box_5[16:23]=subbyte5[16:23] ^ keyi;
		dynamic_s_box_5[24:31]=subbyte5[24:31] ^ keyi;
		dynamic_s_box_5[32:39]=subbyte5[32:39] ^ keyi;
		dynamic_s_box_5[40:47]=subbyte5[40:47] ^ keyi;
		dynamic_s_box_5[48:55]=subbyte5[48:55] ^ keyi;
		dynamic_s_box_5[56:63]=subbyte5[56:63] ^ keyi;
		dynamic_s_box_5[64:71]=subbyte5[64:71] ^ keyi;
		dynamic_s_box_5[72:79]=subbyte5[72:79] ^ keyi;
		dynamic_s_box_5[80:87]=subbyte5[80:87] ^ keyi;
		dynamic_s_box_5[88:95]=subbyte5[88:95] ^ keyi;
		dynamic_s_box_5[96:103]=subbyte5[96:103] ^ keyi;
		dynamic_s_box_5[104:111]=subbyte5[104:111] ^ keyi;
		dynamic_s_box_5[112:119]=subbyte5[112:119] ^ keyi;
		dynamic_s_box_5[120:127]=subbyte5[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_6;
	input [0:7]keyi;
	begin
		dynamic_s_box_6[0:7]=subbyte6[0:7] ^ keyi;
		dynamic_s_box_6[8:15]=subbyte6[8:15] ^ keyi;
		dynamic_s_box_6[16:23]=subbyte6[16:23] ^ keyi;
		dynamic_s_box_6[24:31]=subbyte6[24:31] ^ keyi;
		dynamic_s_box_6[32:39]=subbyte6[32:39] ^ keyi;
		dynamic_s_box_6[40:47]=subbyte6[40:47] ^ keyi;
		dynamic_s_box_6[48:55]=subbyte6[48:55] ^ keyi;
		dynamic_s_box_6[56:63]=subbyte6[56:63] ^ keyi;
		dynamic_s_box_6[64:71]=subbyte6[64:71] ^ keyi;
		dynamic_s_box_6[72:79]=subbyte6[72:79] ^ keyi;
		dynamic_s_box_6[80:87]=subbyte6[80:87] ^ keyi;
		dynamic_s_box_6[88:95]=subbyte6[88:95] ^ keyi;
		dynamic_s_box_6[96:103]=subbyte6[96:103] ^ keyi;
		dynamic_s_box_6[104:111]=subbyte6[104:111] ^ keyi;
		dynamic_s_box_6[112:119]=subbyte6[112:119] ^ keyi;
		dynamic_s_box_6[120:127]=subbyte6[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_7;
	input [0:7]keyi;
	begin
		dynamic_s_box_7[0:7]=subbyte7[0:7] ^ keyi;
		dynamic_s_box_7[8:15]=subbyte7[8:15] ^ keyi;
		dynamic_s_box_7[16:23]=subbyte7[16:23] ^ keyi;
		dynamic_s_box_7[24:31]=subbyte7[24:31] ^ keyi;
		dynamic_s_box_7[32:39]=subbyte7[32:39] ^ keyi;
		dynamic_s_box_7[40:47]=subbyte7[40:47] ^ keyi;
		dynamic_s_box_7[48:55]=subbyte7[48:55] ^ keyi;
		dynamic_s_box_7[56:63]=subbyte7[56:63] ^ keyi;
		dynamic_s_box_7[64:71]=subbyte7[64:71] ^ keyi;
		dynamic_s_box_7[72:79]=subbyte7[72:79] ^ keyi;
		dynamic_s_box_7[80:87]=subbyte7[80:87] ^ keyi;
		dynamic_s_box_7[88:95]=subbyte7[88:95] ^ keyi;
		dynamic_s_box_7[96:103]=subbyte7[96:103] ^ keyi;
		dynamic_s_box_7[104:111]=subbyte7[104:111] ^ keyi;
		dynamic_s_box_7[112:119]=subbyte7[112:119] ^ keyi;
		dynamic_s_box_7[120:127]=subbyte7[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_8;
	input [0:7]keyi;
	begin
		dynamic_s_box_8[0:7]=subbyte8[0:7] ^ keyi;
		dynamic_s_box_8[8:15]=subbyte8[8:15] ^ keyi;
		dynamic_s_box_8[16:23]=subbyte8[16:23] ^ keyi;
		dynamic_s_box_8[24:31]=subbyte8[24:31] ^ keyi;
		dynamic_s_box_8[32:39]=subbyte8[32:39] ^ keyi;
		dynamic_s_box_8[40:47]=subbyte8[40:47] ^ keyi;
		dynamic_s_box_8[48:55]=subbyte8[48:55] ^ keyi;
		dynamic_s_box_8[56:63]=subbyte8[56:63] ^ keyi;
		dynamic_s_box_8[64:71]=subbyte8[64:71] ^ keyi;
		dynamic_s_box_8[72:79]=subbyte8[72:79] ^ keyi;
		dynamic_s_box_8[80:87]=subbyte8[80:87] ^ keyi;
		dynamic_s_box_8[88:95]=subbyte8[88:95] ^ keyi;
		dynamic_s_box_8[96:103]=subbyte8[96:103] ^ keyi;
		dynamic_s_box_8[104:111]=subbyte8[104:111] ^ keyi;
		dynamic_s_box_8[112:119]=subbyte8[112:119] ^ keyi;
		dynamic_s_box_8[120:127]=subbyte8[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_9;
	input [0:7]keyi;
	begin
		dynamic_s_box_9[0:7]=subbyte9[0:7] ^ keyi;
		dynamic_s_box_9[8:15]=subbyte9[8:15] ^ keyi;
		dynamic_s_box_9[16:23]=subbyte9[16:23] ^ keyi;
		dynamic_s_box_9[24:31]=subbyte9[24:31] ^ keyi;
		dynamic_s_box_9[32:39]=subbyte9[32:39] ^ keyi;
		dynamic_s_box_9[40:47]=subbyte9[40:47] ^ keyi;
		dynamic_s_box_9[48:55]=subbyte9[48:55] ^ keyi;
		dynamic_s_box_9[56:63]=subbyte9[56:63] ^ keyi;
		dynamic_s_box_9[64:71]=subbyte9[64:71] ^ keyi;
		dynamic_s_box_9[72:79]=subbyte9[72:79] ^ keyi;
		dynamic_s_box_9[80:87]=subbyte9[80:87] ^ keyi;
		dynamic_s_box_9[88:95]=subbyte9[88:95] ^ keyi;
		dynamic_s_box_9[96:103]=subbyte9[96:103] ^ keyi;
		dynamic_s_box_9[104:111]=subbyte9[104:111] ^ keyi;
		dynamic_s_box_9[112:119]=subbyte9[112:119] ^ keyi;
		dynamic_s_box_9[120:127]=subbyte9[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_a;
	input [0:7]keyi;
	begin
		dynamic_s_box_a[0:7]=subbytea[0:7] ^ keyi;
		dynamic_s_box_a[8:15]=subbytea[8:15] ^ keyi;
		dynamic_s_box_a[16:23]=subbytea[16:23] ^ keyi;
		dynamic_s_box_a[24:31]=subbytea[24:31] ^ keyi;
		dynamic_s_box_a[32:39]=subbytea[32:39] ^ keyi;
		dynamic_s_box_a[40:47]=subbytea[40:47] ^ keyi;
		dynamic_s_box_a[48:55]=subbytea[48:55] ^ keyi;
		dynamic_s_box_a[56:63]=subbytea[56:63] ^ keyi;
		dynamic_s_box_a[64:71]=subbytea[64:71] ^ keyi;
		dynamic_s_box_a[72:79]=subbytea[72:79] ^ keyi;
		dynamic_s_box_a[80:87]=subbytea[80:87] ^ keyi;
		dynamic_s_box_a[88:95]=subbytea[88:95] ^ keyi;
		dynamic_s_box_a[96:103]=subbytea[96:103] ^ keyi;
		dynamic_s_box_a[104:111]=subbytea[104:111] ^ keyi;
		dynamic_s_box_a[112:119]=subbytea[112:119] ^ keyi;
		dynamic_s_box_a[120:127]=subbytea[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_b;
	input [0:7]keyi;
	begin
		dynamic_s_box_b[0:7]=subbyteb[0:7] ^ keyi;
		dynamic_s_box_b[8:15]=subbyteb[8:15] ^ keyi;
		dynamic_s_box_b[16:23]=subbyteb[16:23] ^ keyi;
		dynamic_s_box_b[24:31]=subbyteb[24:31] ^ keyi;
		dynamic_s_box_b[32:39]=subbyteb[32:39] ^ keyi;
		dynamic_s_box_b[40:47]=subbyteb[40:47] ^ keyi;
		dynamic_s_box_b[48:55]=subbyteb[48:55] ^ keyi;
		dynamic_s_box_b[56:63]=subbyteb[56:63] ^ keyi;
		dynamic_s_box_b[64:71]=subbyteb[64:71] ^ keyi;
		dynamic_s_box_b[72:79]=subbyteb[72:79] ^ keyi;
		dynamic_s_box_b[80:87]=subbyteb[80:87] ^ keyi;
		dynamic_s_box_b[88:95]=subbyteb[88:95] ^ keyi;
		dynamic_s_box_b[96:103]=subbyteb[96:103] ^ keyi;
		dynamic_s_box_b[104:111]=subbyteb[104:111] ^ keyi;
		dynamic_s_box_b[112:119]=subbyteb[112:119] ^ keyi;
		dynamic_s_box_b[120:127]=subbyteb[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_c;
	input [0:7]keyi;
	begin
		dynamic_s_box_c[0:7]=subbytec[0:7] ^ keyi;
		dynamic_s_box_c[8:15]=subbytec[8:15] ^ keyi;
		dynamic_s_box_c[16:23]=subbytec[16:23] ^ keyi;
		dynamic_s_box_c[24:31]=subbytec[24:31] ^ keyi;
		dynamic_s_box_c[32:39]=subbytec[32:39] ^ keyi;
		dynamic_s_box_c[40:47]=subbytec[40:47] ^ keyi;
		dynamic_s_box_c[48:55]=subbytec[48:55] ^ keyi;
		dynamic_s_box_c[56:63]=subbytec[56:63] ^ keyi;
		dynamic_s_box_c[64:71]=subbytec[64:71] ^ keyi;
		dynamic_s_box_c[72:79]=subbytec[72:79] ^ keyi;
		dynamic_s_box_c[80:87]=subbytec[80:87] ^ keyi;
		dynamic_s_box_c[88:95]=subbytec[88:95] ^ keyi;
		dynamic_s_box_c[96:103]=subbytec[96:103] ^ keyi;
		dynamic_s_box_c[104:111]=subbytec[104:111] ^ keyi;
		dynamic_s_box_c[112:119]=subbytec[112:119] ^ keyi;
		dynamic_s_box_c[120:127]=subbytec[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_d;
	input [0:7]keyi;
	begin
		dynamic_s_box_d[0:7]=subbyted[0:7] ^ keyi;
		dynamic_s_box_d[8:15]=subbyted[8:15] ^ keyi;
		dynamic_s_box_d[16:23]=subbyted[16:23] ^ keyi;
		dynamic_s_box_d[24:31]=subbyted[24:31] ^ keyi;
		dynamic_s_box_d[32:39]=subbyted[32:39] ^ keyi;
		dynamic_s_box_d[40:47]=subbyted[40:47] ^ keyi;
		dynamic_s_box_d[48:55]=subbyted[48:55] ^ keyi;
		dynamic_s_box_d[56:63]=subbyted[56:63] ^ keyi;
		dynamic_s_box_d[64:71]=subbyted[64:71] ^ keyi;
		dynamic_s_box_d[72:79]=subbyted[72:79] ^ keyi;
		dynamic_s_box_d[80:87]=subbyted[80:87] ^ keyi;
		dynamic_s_box_d[88:95]=subbyted[88:95] ^ keyi;
		dynamic_s_box_d[96:103]=subbyted[96:103] ^ keyi;
		dynamic_s_box_d[104:111]=subbyted[104:111] ^ keyi;
		dynamic_s_box_d[112:119]=subbyted[112:119] ^ keyi;
		dynamic_s_box_d[120:127]=subbyted[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_e;
	input [0:7]keyi;
	begin
		dynamic_s_box_e[0:7]=subbytee[0:7] ^ keyi;
		dynamic_s_box_e[8:15]=subbytee[8:15] ^ keyi;
		dynamic_s_box_e[16:23]=subbytee[16:23] ^ keyi;
		dynamic_s_box_e[24:31]=subbytee[24:31] ^ keyi;
		dynamic_s_box_e[32:39]=subbytee[32:39] ^ keyi;
		dynamic_s_box_e[40:47]=subbytee[40:47] ^ keyi;
		dynamic_s_box_e[48:55]=subbytee[48:55] ^ keyi;
		dynamic_s_box_e[56:63]=subbytee[56:63] ^ keyi;
		dynamic_s_box_e[64:71]=subbytee[64:71] ^ keyi;
		dynamic_s_box_e[72:79]=subbytee[72:79] ^ keyi;
		dynamic_s_box_e[80:87]=subbytee[80:87] ^ keyi;
		dynamic_s_box_e[88:95]=subbytee[88:95] ^ keyi;
		dynamic_s_box_e[96:103]=subbytee[96:103] ^ keyi;
		dynamic_s_box_e[104:111]=subbytee[104:111] ^ keyi;
		dynamic_s_box_e[112:119]=subbytee[112:119] ^ keyi;
		dynamic_s_box_e[120:127]=subbytee[120:127] ^ keyi;
	end
endfunction

function [0:127]dynamic_s_box_f;
	input [0:7]keyi;
	begin
		dynamic_s_box_f[0:7]=subbytef[0:7] ^ keyi;
		dynamic_s_box_f[8:15]=subbytef[8:15] ^ keyi;
		dynamic_s_box_f[16:23]=subbytef[16:23] ^ keyi;
		dynamic_s_box_f[24:31]=subbytef[24:31] ^ keyi;
		dynamic_s_box_f[32:39]=subbytef[32:39] ^ keyi;
		dynamic_s_box_f[40:47]=subbytef[40:47] ^ keyi;
		dynamic_s_box_f[48:55]=subbytef[48:55] ^ keyi;
		dynamic_s_box_f[56:63]=subbytef[56:63] ^ keyi;
		dynamic_s_box_f[64:71]=subbytef[64:71] ^ keyi;
		dynamic_s_box_f[72:79]=subbytef[72:79] ^ keyi;
		dynamic_s_box_f[80:87]=subbytef[80:87] ^ keyi;
		dynamic_s_box_f[88:95]=subbytef[88:95] ^ keyi;
		dynamic_s_box_f[96:103]=subbytef[96:103] ^ keyi;
		dynamic_s_box_f[104:111]=subbytef[104:111] ^ keyi;
		dynamic_s_box_f[112:119]=subbytef[112:119] ^ keyi;
		dynamic_s_box_f[120:127]=subbytef[120:127] ^ keyi;
	end
endfunction

function [0:31]subbyte;
  input [0:31]aes_matrix;
  input [0:127]d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef;
  //input [0:127]K;
  reg [0:7]a; reg [0:3]a1; reg [0:3]a2;
  reg [0:127]b1;
  //reg [0:127]d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef;
  integer i;
  begin
  
  /*if (K[0:7]==8'h00) begin
	 d_subbyte0=dynamic_s_box_0(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 d_subbyte1=dynamic_s_box_1(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 d_subbyte2=dynamic_s_box_2(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 d_subbyte3=dynamic_s_box_3(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 d_subbyte4=dynamic_s_box_4(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 d_subbyte5=dynamic_s_box_5(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyte6=dynamic_s_box_6(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyte7=dynamic_s_box_7(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyte8=dynamic_s_box_8(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyte9=dynamic_s_box_9(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbytea=dynamic_s_box_a(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyteb=dynamic_s_box_b(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbytec=dynamic_s_box_c(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbyted=dynamic_s_box_d(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbytee=dynamic_s_box_e(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);	 
	 d_subbytef=dynamic_s_box_f(K[0:7] ^ K[8:15] ^ K[16:23] ^ K[24:31] ^ K[32:39] ^ K[40:47] ^ K[48:55] ^ K[56:63] ^ K[64:71] ^ K[72:79] ^ K[80:87] ^ K[88:95] ^ K[96:103] ^ K[104:111] ^ K[112:119] ^ K[120:127]);
	 end
	 else begin
	 d_subbyte0=dynamic_s_box_0(K[0:7]);
	 d_subbyte1=dynamic_s_box_1(K[0:7]);
	 d_subbyte2=dynamic_s_box_2(K[0:7]);
	 d_subbyte3=dynamic_s_box_3(K[0:7]);
	 d_subbyte4=dynamic_s_box_4(K[0:7]);
	 d_subbyte5=dynamic_s_box_5(K[0:7]);	 
	 d_subbyte6=dynamic_s_box_6(K[0:7]);	 
	 d_subbyte7=dynamic_s_box_7(K[0:7]);	 
	 d_subbyte8=dynamic_s_box_8(K[0:7]);	 
	 d_subbyte9=dynamic_s_box_9(K[0:7]);	 
	 d_subbytea=dynamic_s_box_a(K[0:7]);	 
	 d_subbyteb=dynamic_s_box_b(K[0:7]);	 
	 d_subbytec=dynamic_s_box_c(K[0:7]);	 
	 d_subbyted=dynamic_s_box_d(K[0:7]);	 
	 d_subbytee=dynamic_s_box_e(K[0:7]);	 
	 d_subbytef=dynamic_s_box_f(K[0:7]);
	 end*/
	 
    for (i=0;i<4;i=i+1)begin
     case (i)
      0: begin
         a=aes_matrix[0:7];  
         a1=a[0:3];
         a2=a[4:7];
         case (a1) //[y2:y3]=[0:3]=a[y2:3]
           0: b1=d_subbyte0;
           1: b1=d_subbyte1;
           2: b1=d_subbyte2;
           3: b1=d_subbyte3;
           4: b1=d_subbyte4;
           5: b1=d_subbyte5;
           6: b1=d_subbyte6;
           7: b1=d_subbyte7;
           8: b1=d_subbyte8;
           9: b1=d_subbyte9;
           4'ha: b1=d_subbytea;
           4'hb: b1=d_subbyteb;
           4'hc: b1=d_subbytec;
           4'hd: b1=d_subbyted;
           4'he: b1=d_subbytee;
           4'hf: b1=d_subbytef;
         endcase
         case (a2) //[y4:y1]=a[4:7]
           0: subbyte[0:7]=b1[0:7];
           1: subbyte[0:7]=b1[8:15];
           2: subbyte[0:7]=b1[16:23];
           3: subbyte[0:7]=b1[24:31];
           4: subbyte[0:7]=b1[32:39];
           5: subbyte[0:7]=b1[40:47];
           6: subbyte[0:7]=b1[48:55];
           7: subbyte[0:7]=b1[56:63];
           8: subbyte[0:7]=b1[64:71];
           9: subbyte[0:7]=b1[72:79];
           4'ha: subbyte[0:7]=b1[80:87];
           4'hb: subbyte[0:7]=b1[88:95];
           4'hc: subbyte[0:7]=b1[96:103];
           4'hd: subbyte[0:7]=b1[104:111];
           4'he: subbyte[0:7]=b1[112:119];
           4'hf: subbyte[0:7]=b1[120:127];
          endcase
       end
       
       1: begin
         a=aes_matrix[8:15];  
         a1=a[0:3];
         a2=a[4:7];
         case (a1) //[y2:y3]=[0:3]=a[y2:3]
           0: b1=d_subbyte0;
           1: b1=d_subbyte1;
           2: b1=d_subbyte2;
           3: b1=d_subbyte3;
           4: b1=d_subbyte4;
           5: b1=d_subbyte5;
           6: b1=d_subbyte6;
           7: b1=d_subbyte7;
           8: b1=d_subbyte8;
           9: b1=d_subbyte9;
           4'ha: b1=d_subbytea;
           4'hb: b1=d_subbyteb;
           4'hc: b1=d_subbytec;
           4'hd: b1=d_subbyted;
           4'he: b1=d_subbytee;
           4'hf: b1=d_subbytef;
         endcase
         case (a2) //[y4:y1]=a[4:7]
           0: subbyte[8:15]=b1[0:7];
           1: subbyte[8:15]=b1[8:15];
           2: subbyte[8:15]=b1[16:23];
           3: subbyte[8:15]=b1[24:31];
           4: subbyte[8:15]=b1[32:39];
           5: subbyte[8:15]=b1[40:47];
           6: subbyte[8:15]=b1[48:55];
           7: subbyte[8:15]=b1[56:63];
           8: subbyte[8:15]=b1[64:71];
           9: subbyte[8:15]=b1[72:79];
           4'ha: subbyte[8:15]=b1[80:87];
           4'hb: subbyte[8:15]=b1[88:95];
           4'hc: subbyte[8:15]=b1[96:103];
           4'hd: subbyte[8:15]=b1[104:111];
           4'he: subbyte[8:15]=b1[112:119];
           4'hf: subbyte[8:15]=b1[120:127];
          endcase
        end
        
       2: begin
         a=aes_matrix[16:23];  
         a1=a[0:3];
         a2=a[4:7];
         case (a1) //[y2:y3]=[0:3]=a[y2:3]
           0: b1=d_subbyte0;
           1: b1=d_subbyte1;
           2: b1=d_subbyte2;
           3: b1=d_subbyte3;
           4: b1=d_subbyte4;
           5: b1=d_subbyte5;
           6: b1=d_subbyte6;
           7: b1=d_subbyte7;
           8: b1=d_subbyte8;
           9: b1=d_subbyte9;
           4'ha: b1=d_subbytea;
           4'hb: b1=d_subbyteb;
           4'hc: b1=d_subbytec;
           4'hd: b1=d_subbyted;
           4'he: b1=d_subbytee;
           4'hf: b1=d_subbytef;
         endcase
         case (a2) //[y4:y1]=a[4:7]
           0: subbyte[16:23]=b1[0:7];
           1: subbyte[16:23]=b1[8:15];
           2: subbyte[16:23]=b1[16:23];
           3: subbyte[16:23]=b1[24:31];
           4: subbyte[16:23]=b1[32:39];
           5: subbyte[16:23]=b1[40:47];
           6: subbyte[16:23]=b1[48:55];
           7: subbyte[16:23]=b1[56:63];
           8: subbyte[16:23]=b1[64:71];
           9: subbyte[16:23]=b1[72:79];
           4'ha: subbyte[16:23]=b1[80:87];
           4'hb: subbyte[16:23]=b1[88:95];
           4'hc: subbyte[16:23]=b1[96:103];
           4'hd: subbyte[16:23]=b1[104:111];
           4'he: subbyte[16:23]=b1[112:119];
           4'hf: subbyte[16:23]=b1[120:127];
          endcase
        end
        
       3: begin
         a=aes_matrix[24:31];  
         a1=a[0:3];
         a2=a[4:7];
         case (a1) //[y2:y3]=[0:3]=a[y2:3]
           0: b1=d_subbyte0;
           1: b1=d_subbyte1;
           2: b1=d_subbyte2;
           3: b1=d_subbyte3;
           4: b1=d_subbyte4;
           5: b1=d_subbyte5;
           6: b1=d_subbyte6;
           7: b1=d_subbyte7;
           8: b1=d_subbyte8;
           9: b1=d_subbyte9;
           4'ha: b1=d_subbytea;
           4'hb: b1=d_subbyteb;
           4'hc: b1=d_subbytec;
           4'hd: b1=d_subbyted;
           4'he: b1=d_subbytee;
           4'hf: b1=d_subbytef;
         endcase
         case (a2) //[y4:y1]=a[4:7]
           0: subbyte[24:31]=b1[0:7];
           1: subbyte[24:31]=b1[8:15];
           2: subbyte[24:31]=b1[16:23];
           3: subbyte[24:31]=b1[24:31];
           4: subbyte[24:31]=b1[32:39];
           5: subbyte[24:31]=b1[40:47];
           6: subbyte[24:31]=b1[48:55];
           7: subbyte[24:31]=b1[56:63];
           8: subbyte[24:31]=b1[64:71];
           9: subbyte[24:31]=b1[72:79];
           4'ha: subbyte[24:31]=b1[80:87];
           4'hb: subbyte[24:31]=b1[88:95];
           4'hc: subbyte[24:31]=b1[96:103];
           4'hd: subbyte[24:31]=b1[104:111];
           4'he: subbyte[24:31]=b1[112:119];
           4'hf: subbyte[24:31]=b1[120:127];
          endcase
        end
      endcase
      
    end
  end
endfunction

function [0:127]mix_col;
  input [0:7]one1,two1,three1,four1,one2,two2,three2,four2,one3,two3,three3,four3,one4,two4,three4,four4;
  reg [0:7]temp1,temp2;
  begin
    //first column of matrix
    temp1=mul_02(one1);
    temp2=mul_03(two1);
    mix_col[0:7]=((temp1 ^ temp2) ^ three1) ^ four1;
    
    temp1=mul_02(two1);
    temp2=mul_03(three1);
    mix_col[8:15]=((one1 ^ temp1) ^ temp2) ^ four1;
    
    temp1=mul_02(three1);
    temp2=mul_03(four1);
    mix_col[16:23]=((one1 ^ two1) ^ temp1) ^ temp2;
    
    temp1=mul_02(four1);
    temp2=mul_03(one1);
    mix_col[24:31]=((temp2 ^ two1) ^ three1) ^ temp1;
    //first 32 bits filled now.
    
    //second column of matrix
    temp1=mul_02(one2);
    temp2=mul_03(two2);
    mix_col[32:39]=((temp1 ^ temp2) ^ three2) ^ four2;
    
    temp1=mul_02(two2);
    temp2=mul_03(three2);
    mix_col[40:47]=((one2 ^ temp1) ^ temp2) ^ four2;
    
    temp1=mul_02(three2);
    temp2=mul_03(four2);
    mix_col[48:55]=((one2 ^ two2) ^ temp1) ^ temp2;
    
    temp1=mul_02(four2);
    temp2=mul_03(one2);
    mix_col[56:63]=((temp2 ^ two2) ^ three2) ^ temp1;
    //total 64 bits filled.
    
    //third column processing
    temp1=mul_02(one3);
    temp2=mul_03(two3);
    mix_col[64:71]=((temp1 ^ temp2) ^ three3) ^ four3;
    
    temp1=mul_02(two3);
    temp2=mul_03(three3);
    mix_col[72:79]=((one3 ^ temp1) ^ temp2) ^ four3;
    
    temp1=mul_02(three3);
    temp2=mul_03(four3);
    mix_col[80:87]=((one3 ^ two3) ^ temp1) ^ temp2;
    
    temp1=mul_02(four3);
    temp2=mul_03(one3);
    mix_col[88:95]=((temp2 ^ two3) ^ three3) ^ temp1;
    //total 96 bits filled.
    
    //fourth column processing
    temp1=mul_02(one4);
    temp2=mul_03(two4);
    mix_col[96:103]=((temp1 ^ temp2) ^ three4) ^ four4;
    
    temp1=mul_02(two4);
    temp2=mul_03(three4);
    mix_col[104:111]=((one4 ^ temp1) ^ temp2) ^ four4;
    
    temp1=mul_02(three4);
    temp2=mul_03(four4);
    mix_col[112:119]=((one4 ^ two4) ^ temp1) ^ temp2;
    
    temp1=mul_02(four4);
    temp2=mul_03(one4);
    mix_col[120:127]=((temp2 ^ two4) ^ three4) ^ temp1;
 
  end
endfunction

//function multiply by 02
function [0:7]mul_02;
  input [0:7]value_02;
  reg [0:7]temp_02;
  parameter r1=8'b00011011;//1B
  parameter r2=8'b00000010;//02
  begin
    if(value_02[0]==1'b0) begin
      mul_02=value_02 * r2;//mul_02=(value_02 * r2) ^ r1;
    end
    else begin
      temp_02=value_02;
      temp_02[0:6]=temp_02[1:7];
      temp_02[7]=1'b0;
      mul_02=temp_02 ^ r1;
    end
  end
endfunction

//function multiply by 03
function [0:7]mul_03;
  input [0:7]value_03;
  reg [0:7]temp_03;
  begin
    temp_03=mul_02(value_03);
    mul_03=temp_03 ^ value_03;
  end
endfunction

//reg [0:3]key_no;
//reg [0:127]key_value_store;

key_schedule l1 (clk,rst_key_schedule,key_in_key_schedule,round_no_key_schedule,key_out_key_schedule);
//memory_key l12 (key_no,key_value_store);

always @ (posedge clk) begin
  if(rst) begin
    enc_state=0;
    b=1'b1;
    //Part 1 begins
    //state=in(data)
    state0[0:7]=data_in[0:7];
	 state0[8:15]=data_in[32:39];
	 state0[16:23]=data_in[64:71];
	 state0[24:31]=data_in[96:103];
	 
	 state1[0:7]=data_in[8:15];
	 state1[8:15]=data_in[40:47];
	 state1[16:23]=data_in[72:79];
	 state1[24:31]=data_in[104:111];
	 
	 state2[0:7]=data_in[16:23];
	 state2[8:15]=data_in[48:55];
	 state2[16:23]=data_in[80:87];
	 state2[24:31]=data_in[112:119];
	 
	 state3[0:7]=data_in[24:31];
	 state3[8:15]=data_in[56:63];
	 state3[16:23]=data_in[88:95];
	 state3[24:31]=data_in[120:127];
	 
	 /*$display("value of state0 = %h",state0);
	 $display("value of state1 = %h",state1);
	 $display("value of state2 = %h",state2);
	 $display("value of state3 = %h",state3);*/
	 
	 //$display("value of input key= %h",key_in);
  end
  else begin
    case (enc_state)
      0: begin
        //Add Round Key operation
        state0[0:7]=state0[0:7] ^ key_in[0:7];
		  state0[8:15]=state0[8:15] ^ key_in[32:39];
		  state0[16:23]=state0[16:23] ^ key_in[64:71];
		  state0[24:31]=state0[24:31] ^ key_in[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_in[8:15];
		  state1[8:15]=state1[8:15] ^ key_in[40:47];
		  state1[16:23]=state1[16:23] ^ key_in[72:79];
		  state1[24:31]=state1[24:31] ^ key_in[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_in[16:23];
		  state2[8:15]=state2[8:15] ^ key_in[48:55];
		  state2[16:23]=state2[16:23] ^ key_in[80:87];
		  state2[24:31]=state2[24:31] ^ key_in[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_in[24:31];
		  state3[8:15]=state3[8:15] ^ key_in[56:63];
		  state3[16:23]=state3[16:23] ^ key_in[88:95];
		  state3[24:31]=state3[24:31] ^ key_in[120:127];
		  
		  //key_value_store=key_in;
		  
		  
		  /**$display("value of state0 = %h",state0);
		  $display("value of state1 = %h",state1);
		  $display("value of state2 = %h",state2);
		  $display("value of state3 = %h",state3);*/
        //Part 1 over.
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_in;
        round_no_key_schedule=4'b0000;
        

			if (key_in[0:7]==8'h00) begin
				d_subbyte0=dynamic_s_box_0(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				d_subbyte1=dynamic_s_box_1(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				d_subbyte2=dynamic_s_box_2(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				d_subbyte3=dynamic_s_box_3(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				d_subbyte4=dynamic_s_box_4(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				d_subbyte5=dynamic_s_box_5(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyte6=dynamic_s_box_6(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyte7=dynamic_s_box_7(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyte8=dynamic_s_box_8(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyte9=dynamic_s_box_9(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbytea=dynamic_s_box_a(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyteb=dynamic_s_box_b(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbytec=dynamic_s_box_c(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbyted=dynamic_s_box_d(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbytee=dynamic_s_box_e(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);	 
				d_subbytef=dynamic_s_box_f(key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127]);
				dynamic_s_box_reg=key_in[0:7] ^ key_in[8:15] ^ key_in[16:23] ^ key_in[24:31] ^ key_in[32:39] ^ key_in[40:47] ^ key_in[48:55] ^ key_in[56:63] ^ key_in[64:71] ^ key_in[72:79] ^ key_in[80:87] ^ key_in[88:95] ^ key_in[96:103] ^ key_in[104:111] ^ key_in[112:119] ^ key_in[120:127];
			end
			else begin
				d_subbyte0=dynamic_s_box_0(key_in[0:7]);
				d_subbyte1=dynamic_s_box_1(key_in[0:7]);
				d_subbyte2=dynamic_s_box_2(key_in[0:7]);
				d_subbyte3=dynamic_s_box_3(key_in[0:7]);
				d_subbyte4=dynamic_s_box_4(key_in[0:7]);
				d_subbyte5=dynamic_s_box_5(key_in[0:7]);	 
				d_subbyte6=dynamic_s_box_6(key_in[0:7]);	 
				d_subbyte7=dynamic_s_box_7(key_in[0:7]);	 
				d_subbyte8=dynamic_s_box_8(key_in[0:7]);	 
				d_subbyte9=dynamic_s_box_9(key_in[0:7]);	 
				d_subbytea=dynamic_s_box_a(key_in[0:7]);	 
				d_subbyteb=dynamic_s_box_b(key_in[0:7]);	 
				d_subbytec=dynamic_s_box_c(key_in[0:7]);	 
				d_subbyted=dynamic_s_box_d(key_in[0:7]);	 
				d_subbytee=dynamic_s_box_e(key_in[0:7]);	 
				d_subbytef=dynamic_s_box_f(key_in[0:7]);
				dynamic_s_box_reg=key_in[0:7];
			end
		  
        if(b) begin
          enc_state=7'b0000001;
        end
        else begin
          enc_state=7'b0000000;
        end
      end
      
      1: begin
        //Part 2 begins.
        //LOOP 1
        
        //$display("value of state0 = %h",state0);
        //$display("value of state1 = %h",state1);
        //$display("value of state2 = %h",state2);
        //$display("value of state3 = %h",state3);
        
        //subybyte operation
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
		  
		  /*$display("value of state0 = %h",aes_matrix0_step1);
        $display("value of state1 = %h",aes_matrix1_step1);
        $display("value of state2 = %h",aes_matrix2_step1);
        $display("value of state3 = %h",aes_matrix3_step1);*/
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
		  
		  //key_no=4'b0000;
        
        if(b) begin
          enc_state=7'b0000010;
        end
        else begin
          enc_state=7'b0000001;
        end
      end
      
      2: begin
       
		  //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
		  
		  /*op_reg[0:31]=aes_matrix0_step1;
		  op_reg[32:63]=aes_matrix1_step1;
		  op_reg[64:95]=aes_matrix2_step1;
		  op_reg[96:127]=aes_matrix3_step1;
		  
		  aes_matrix0_step1[0:7]=op_reg[0:7];
		  aes_matrix0_step1[8:15]=op_reg[40:47];
		  aes_matrix0_step1[16:23]=op_reg[80:87];
		  aes_matrix0_step1[24:31]=op_reg[120:127];
		  
		  aes_matrix1_step1[0:7]=op_reg[32:39];
		  aes_matrix1_step1[8:15]=op_reg[72:79];
		  aes_matrix1_step1[16:23]=op_reg[112:119];
		  aes_matrix1_step1[24:31]=op_reg[24:31];
		  
		  aes_matrix2_step1[0:7]=op_reg[64:71];
		  aes_matrix2_step1[8:15]=op_reg[104:111];
		  aes_matrix2_step1[16:23]=op_reg[16:23];
		  aes_matrix2_step1[24:31]=op_reg[56:63];
		  
		  aes_matrix3_step1[0:7]=op_reg[96:103];
		  aes_matrix3_step1[8:15]=op_reg[8:15];
		  aes_matrix3_step1[16:23]=op_reg[48:55];
		  aes_matrix3_step1[24:31]=op_reg[88:95];*/
        
		  /*$display("value of state0 = %h",aes_matrix0_step1);
        $display("value of state1 = %h",aes_matrix1_step1);
        $display("value of state2 = %h",aes_matrix2_step1);
        $display("value of state3 = %h",aes_matrix3_step1);*/
		  
        if(b) begin
          enc_state=7'b0000011;
        end
        else begin
          enc_state=7'b0000010;
        end
      end
      
      3: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0000100;
        end
        else begin
          enc_state=7'b0000011;
        end
      end
      
      4: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        /*$display("value of state0 = %h",state0);
        $display("value of state1 = %h",state1);
        $display("value of state2 = %h",state2);
        $display("value of state3 = %h",state3);*/
        
        if(b) begin
          enc_state=7'b0000101;
        end
        else begin
          enc_state=7'b0000100;
        end
      end
      
      5: begin
        //empty stage, waiting for key 1 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0000110;
        end
        else begin
          enc_state=7'b0000101;
        end
      end
      
      6: begin
        //empty stage, waiting for key 1 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0000111;
        end
        else begin
          enc_state=7'b0000110;
        end
      end
      
      7: begin
        //empty stage, waiting for key 1 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0001000;
        end
        else begin
          enc_state=7'b0000111;
        end
      end
      
      8: begin
        //empty stage, waiting for key 1 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0001001;
        end
        else begin
          enc_state=7'b0001000;
        end
      end
      
      9: begin
        //add round key operation
		  
		  /*$display("value of state0 = %h",state0);
        $display("value of state1 = %h",state1);
        $display("value of state2 = %h",state2);*/
        //$display(" 1 value of key_out_key_schedule = %h",key_out_key_schedule);
		  
        //Add Round Key operation
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
		  
		  /*$display("value of state0 = %h",state0);
        $display("value of state1 = %h",state1);
        $display("value of state2 = %h",state2);
        $display("value of state3 = %h",state3);*/
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0001;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
		  
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0000;
        //$display("key_generated @ 0000 i.e..key_1 = %h",key_out_key_schedule);
		  
        //LOOP 1 over.
        if(b) begin
          enc_state=7'b0001010;
        end
        else begin
          enc_state=7'b0001001;
        end
      end
      
      10: begin
        //LOOP 2 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
		  
		  /*$display("value of state0 = %h",aes_matrix0_step1);
        $display("value of state1 = %h",aes_matrix1_step1);
        $display("value of state2 = %h",aes_matrix2_step1);
        $display("value of state3 = %h",aes_matrix3_step1);*/
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
		  
		  //key_no=4'b0001;
        
        if(b) begin
          enc_state=7'b0001011;
        end
        else begin
          enc_state=7'b0001010;
        end 
      end
      
      11: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
		  /*$display("value of state0 = %h",aes_matrix0_step1);
        $display("value of state1 = %h",aes_matrix1_step1);
        $display("value of state2 = %h",aes_matrix2_step1);
        $display("value of state3 = %h",aes_matrix3_step1);*/
		  
        if(b) begin
          enc_state=7'b0001100;
        end
        else begin
          enc_state=7'b0001011;
        end 
      end
      
      12: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0001101;
        end
        else begin
          enc_state=7'b0001100;
        end
      end
      
      13: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
		  /*$display("value of state0 = %h",state0);
        $display("value of state1 = %h",state1);
        $display("value of state2 = %h",state2);
        $display("value of state3 = %h",state3);*/
		  
        if(b) begin
          enc_state=7'b0001110;
        end
        else begin
          enc_state=7'b0001101;
        end
      end
      
      14: begin
        //empty stage, waiting for key 2 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0001111;
        end
        else begin
          enc_state=7'b0001110;
        end
      end
      
      15: begin
        //empty stage, waiting for key 2 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0010000;
        end
        else begin
          enc_state=7'b0001111;
        end
      end
      
      16: begin
        //empty stage, waiting for key 2 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0010001;
        end
        else begin
          enc_state=7'b0010000;
        end
      end
      
      17: begin
        //empty stage, waiting for key 2 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0010010;
        end
        else begin
          enc_state=7'b0010000;
        end
      end
      
      18: begin
        //Add Round Key operation
		  
		  //$display(" 2 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
		  
		  /*$display("value of state0 = %h",state0);
        $display("value of state1 = %h",state1);
        $display("value of state2 = %h",state2);
        $display("value of state3 = %h",state3);*/
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0010;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0001;
		  //$display("key_generated @ 0001 i.e..key_2 = %h",key_out_key_schedule);
		  
        //LOOP 2 over.
        if(b) begin
          enc_state=7'b0010011;
        end
        else begin
          enc_state=7'b0010010;
        end
      end
      
      19: begin
        //LOOP 3 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0010;
		  
        if(b) begin
          enc_state=7'b0010100;
        end
        else begin
          enc_state=7'b0010011;
        end
      end
      
      20: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23]; 
        
        if(b) begin
          enc_state=7'b0010101;
        end
        else begin
          enc_state=7'b0010100;
        end
      end
      
      21: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0010110;
        end
        else begin
          enc_state=7'b0010101;
        end
      end
      
      22: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b0010111;
        end
        else begin
          enc_state=7'b0010110;
        end
      end
      
      23: begin
        //empty stage, waiting for key 3 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0011000;
        end
        else begin
          enc_state=7'b0010111;
        end
      end
      
      24: begin
        //empty stage, waiting for key 3 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0011001;
        end
        else begin
          enc_state=7'b0011000;
        end
      end
      
      25: begin
        //empty stage, waiting for key 3 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0011010;
        end
        else begin
          enc_state=7'b0011001;
        end
      end
      
      26: begin
        //empty stage, waiting for key 3 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0011011;
        end
        else begin
          enc_state=7'b0011010;
        end
      end
      
      27: begin
        //Add Round Key operation
		  
		  //$display(" 3 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0011;
        
        /*$display("value of 4 state0 = %h",state0);
        $display("value of 4 state1 = %h",state1);
        $display("value of 4 state2 = %h",state2);
        $display("value of 4 state3 = %h",state3);*/
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0010;
		  //$display("key_generated @ 0010 i.e..key_3 = %h",key_out_key_schedule);
		  
        //LOOP 3 over.
        if(b) begin
          enc_state=7'b0011100;
        end
        else begin
          enc_state=7'b0011011;
        end
      end
      
      28: begin
        //LOOP 4 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0011;
		  
        if(b) begin
          enc_state=7'b0011101;
        end
        else begin
          enc_state=7'b0011100;
        end
      end
      
      29: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b0011110;
        end
        else begin
          enc_state=7'b0011101;
        end
      end
      
      30: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0011111;
        end
        else begin
          enc_state=7'b0011110;
        end
      end
      
      31: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b0100000;
        end
        else begin
          enc_state=7'b0011111;
        end
      end
      
      32: begin
        //empty stage, waiting for key 4 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0100001;
        end
        else begin
          enc_state=7'b0100000;
        end
      end
      
      33: begin
        //empty stage, waiting for key 4 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0100010;
        end
        else begin
          enc_state=7'b0100001;
        end
      end
      
      34: begin
        //empty stage, waiting for key 4 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0100011;
        end
        else begin
          enc_state=7'b0100010;
        end
      end
      
      35: begin
        //empty stage, waiting for key 4 to come from key schedule.
        
        if(b) begin
          enc_state=7'b0100100;
        end
        else begin
          enc_state=7'b0100011;
        end
      end
      
      36: begin
        //Add Round Key operation
		  
		  //$display(" 4 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0100;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
  		  key_out=key_out_key_schedule;
		  key_store_no=4'b0011;
		  //$display("key_generated @ 0011 i.e..key_4 = %h",key_out_key_schedule);

		  
        //LOOP 4 over.
        if(b) begin
          enc_state=7'b0100101;
        end
        else begin
          enc_state=7'b0100100;
        end
      end
      
      37: begin
        //LOOP 5 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0100;
		  
        if(b) begin
          enc_state=7'b0100110;
        end
        else begin
          enc_state=7'b0100101;
        end
      end
      
      38: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b0100111;
        end
        else begin
          enc_state=7'b0100110;
        end
      end
      
      39: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0101000;
        end
        else begin
          enc_state=7'b0100111;
        end
      end
      
      40: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b0101001;
        end
        else begin
          enc_state=7'b0101000;
        end
      end
      
      41: begin
        //empty stage, waiting for key 5 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0101010;
        end
        else begin
          enc_state=7'b0101001;
        end
      end
      
      42: begin
        //empty stage, waiting for key 5 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0101011;
        end
        else begin
          enc_state=7'b0101010;
        end
      end
      
      43: begin
        //empty stage, waiting for key 5 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0101100;
        end
        else begin
          enc_state=7'b0101011;
        end
      end
      
      44: begin
        //empty stage, waiting for key 5 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0101101;
        end
        else begin
          enc_state=7'b0101100;
        end
      end
      
      45: begin
        //Add Round Key operation
		  
		  //$display(" 5 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0101;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0100;
		  //$display("key_generated @ 0100 i.e..key_5 = %h",key_out_key_schedule);

		  
        //LOOP 5 over.
        if(b) begin
          enc_state=7'b0101110;
        end
        else begin
          enc_state=7'b0101101;
        end
      end
      
      46: begin
        //LOOP 6 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0101;
		  
        if(b) begin
          enc_state=7'b0101111;
        end
        else begin
          enc_state=7'b0101110;
        end
      end
      
      47: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b0110000;
        end
        else begin
          enc_state=7'b0101111;
        end
      end
      
      48: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0110001;
        end
        else begin
          enc_state=7'b0110000;
        end
      end
      
      49: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b0110010;
        end
        else begin
          enc_state=7'b0110001;
        end
      end
      
      50: begin
        //empty stage, waiting for key 6 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0110011;
        end
        else begin
          enc_state=7'b0110010;
        end
      end
      
      51: begin
        //empty stage, waiting for key 6 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0110100;
        end
        else begin
          enc_state=7'b0110011;
        end
      end
      
      52: begin
        //empty stage, waiting for key 6 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0110101;
        end
        else begin
          enc_state=7'b0110100;
        end
      end
      
      53: begin
        //empty stage, waiting for key 6 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0110110;
        end
        else begin
          enc_state=7'b0110101;
        end
      end
      
      54: begin
        //Add Round Key operation
		  
		  //$display(" 6 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0110;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0101;
		  //$display("key_generated @ 0101 i.e..key_6 = %h",key_out_key_schedule);

		  
        //LOOP 6 over.
        if(b) begin
          enc_state=7'b0110111;
        end
        else begin
          enc_state=7'b0110110;
        end
      end
      
      55: begin
        //LOOP 7 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0110;
		  
        if(b) begin
          enc_state=7'b0111000;
        end
        else begin
          enc_state=7'b0110111;
        end
      end
      
      56: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b0111001;
        end
        else begin
          enc_state=7'b0111000;
        end
      end
      
      57: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b0111010;
        end
        else begin
          enc_state=7'b0111001;
        end
      end
      
      58: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b0111011;
        end
        else begin
          enc_state=7'b0111010;
        end
      end
      
      59: begin
        //empty stage, waiting for key 7 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0111100;
        end
        else begin
          enc_state=7'b0111011;
        end
      end
      
      60: begin
        //empty stage, waiting for key 7 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0111101;
        end
        else begin
          enc_state=7'b0111100;
        end
      end
      
      61: begin
        //empty stage, waiting for key 7 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0111110;
        end
        else begin
          enc_state=7'b0111101;
        end
      end
      
      62: begin
        //empty stage, waiting for key 7 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b0111111;
        end
        else begin
          enc_state=7'b0111110;
        end
      end
      
      63: begin
        //Add Round Key operation
		  
		  //$display(" 7 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b0111;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0110;
		  //$display("key_generated @ 0110 i.e..key_7 = %h",key_out_key_schedule);

		  
        //LOOP 7 over.
        if(b) begin
          enc_state=7'b1000000;
        end
        else begin
          enc_state=7'b0111111;
        end
      end
      
      64: begin
        //LOOP 8 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b0111;
		  
        if(b) begin
          enc_state=7'b1000001;
        end
        else begin
          enc_state=7'b1000000;
        end
      end
      
      65: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b1000010;
        end
        else begin
          enc_state=7'b1000001;
        end
      end
      
      66: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b1000011;
        end
        else begin
          enc_state=7'b1000010;
        end
      end
      
      67: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b1000100;
        end
        else begin
          enc_state=7'b1000011;
        end
      end
      
      68: begin
        //empty stage, waiting for key 8 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1000101;
        end
        else begin
          enc_state=7'b1000100;
        end
      end
      
      69: begin
        //empty stage, waiting for key 8 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1000110;
        end
        else begin
          enc_state=7'b1000101;
        end
      end
      
      70: begin
        //empty stage, waiting for key 8 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1000111;
        end
        else begin
          enc_state=7'b1000110;
        end
      end
      
      71: begin
        //empty stage, waiting for key 8 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1001000;
        end
        else begin
          enc_state=7'b1000111;
        end
      end
      
      72: begin
        //Add Round Key operation
		  
		  //$display(" 8 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b1000;
        
        //$display("value of 4 state0 = %h",state0);
        //$display("value of 4 state1 = %h",state1);
        //$display("value of 4 state2 = %h",state2);
        //$display("value of 4 state3 = %h",state3);
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b0111;
		  //$display("key_generated @ 0111 i.e..key_8 = %h",key_out_key_schedule);

		  
        //LOOP 8 over.
        if(b) begin
          enc_state=7'b1001001;
        end
        else begin
          enc_state=7'b1001000;
        end
      end
      
      73: begin
        //LOOP 9 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b1000;
		  
        if(b) begin
          enc_state=7'b1001010;
        end
        else begin
          enc_state=7'b1001001;
        end
      end
      
      74: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b1001011;
        end
        else begin
          enc_state=7'b1001010;
        end
      end
      
      75: begin
        //mix column operation.
        op_reg=mix_col(aes_matrix0_step1[0:7],aes_matrix1_step1[0:7],aes_matrix2_step1[0:7],aes_matrix3_step1[0:7],aes_matrix0_step1[8:15],aes_matrix1_step1[8:15],aes_matrix2_step1[8:15],aes_matrix3_step1[8:15],aes_matrix0_step1[16:23],aes_matrix1_step1[16:23],aes_matrix2_step1[16:23],aes_matrix3_step1[16:23],aes_matrix0_step1[24:31],aes_matrix1_step1[24:31],aes_matrix2_step1[24:31],aes_matrix3_step1[24:31]);
        
        if(b) begin
          enc_state=7'b1001100;
        end
        else begin
          enc_state=7'b1001011;
        end
      end
      
      76: begin
        //arranging state matrix
        state0[0:7]=op_reg[0:7];
        state0[8:15]=op_reg[32:39];
        state0[16:23]=op_reg[64:71];
        state0[24:31]=op_reg[96:103];
        state1[0:7]=op_reg[8:15];
        state1[8:15]=op_reg[40:47];
        state1[16:23]=op_reg[72:79];
        state1[24:31]=op_reg[104:111];
        state2[0:7]=op_reg[16:23];
        state2[8:15]=op_reg[48:55];
        state2[16:23]=op_reg[80:87];
        state2[24:31]=op_reg[112:119];
        state3[0:7]=op_reg[24:31];
        state3[8:15]=op_reg[56:63];
        state3[16:23]=op_reg[88:95];
        state3[24:31]=op_reg[120:127];
        
        if(b) begin
          enc_state=7'b1001101;
        end
        else begin
          enc_state=7'b1001100;
        end
      end
      
      77: begin
        //empty stage, waiting for key 9 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1001110;
        end
        else begin
          enc_state=7'b1001101;
        end
      end
      
      78: begin
        //empty stage, waiting for key 9 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1001111;
        end
        else begin
          enc_state=7'b1001110;
        end
      end
      
      79: begin
        //empty stage, waiting for key 9 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1010000;
        end
        else begin
          enc_state=7'b1001111;
        end
      end
      
      80: begin
        //empty stage, waiting for key 9 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1010001;
        end
        else begin
          enc_state=7'b1010000;
        end
      end
      
      81: begin
        //Add Round Key operation
		  
		  //$display(" 9 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
        
        //key_schedule operation set up.
        rst_key_schedule=1'b1;
        key_in_key_schedule=key_out_key_schedule;
        round_no_key_schedule=4'b1001;
        
        /*$display("value of 4 state0 = %h",state0);
        $display("value of 4 state1 = %h",state1);
        $display("value of 4 state2 = %h",state2);
        $display("value of 4 state3 = %h",state3);*/
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b1000;
		  //$display("key_generated @ 1000 i.e..key_9 = %h",key_out_key_schedule);

		  
        //LOOP 9 over.
        //Part 2 over.
        if(b) begin
          enc_state=7'b1010010;
        end
        else begin
          enc_state=7'b1010001;
        end
      end
      
      82: begin
        //Part 3 begins.
        aes_matrix0_step1=subbyte(state0,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix1_step1=subbyte(state1,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix2_step1=subbyte(state2,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        aes_matrix3_step1=subbyte(state3,d_subbyte0,d_subbyte1,d_subbyte2,d_subbyte3,d_subbyte4,d_subbyte5,d_subbyte6,d_subbyte7,d_subbyte8,d_subbyte9,d_subbytea,d_subbyteb,d_subbytec,d_subbyted,d_subbytee,d_subbytef);
        
        //key schedule operation set up.
        rst_key_schedule=1'b0;
        
		  //key_no=4'b1001;
		  
        if(b) begin
          enc_state=7'b1010011;
        end
        else begin
          enc_state=7'b1010010;
        end
      end
      
      83: begin
        //shiftrow operation
        //shift row operation not applied on first row.
        
        //shift row operation of standard AES 128 on second row.
        op_reg[0:7]=aes_matrix1_step1[0:7];
        aes_matrix1_step1[0:7]=aes_matrix1_step1[8:15];
        aes_matrix1_step1[8:15]=aes_matrix1_step1[16:23];
        aes_matrix1_step1[16:23]=aes_matrix1_step1[24:31];
        aes_matrix1_step1[24:31]=op_reg[0:7];
        
        //shift row operation of standard AES 128 on third row.
        op_reg[0:15]=aes_matrix2_step1[0:15];
        aes_matrix2_step1[0:7]=aes_matrix2_step1[16:23];
        aes_matrix2_step1[8:15]=aes_matrix2_step1[24:31];
        aes_matrix2_step1[16:31]=op_reg[0:15];
        
        //shift row operation of standard AES 128 on fourth row.
        op_reg[0:23]=aes_matrix3_step1[0:23];
        aes_matrix3_step1[0:7]=aes_matrix3_step1[24:31];
        aes_matrix3_step1[8:31]=op_reg[0:23];
        
        if(b) begin
          enc_state=7'b1010100;
        end
        else begin
          enc_state=7'b1010011;
        end
      end
      
      84: begin
        //arranging state matrix
        state0=aes_matrix0_step1;
        state1=aes_matrix1_step1;
        state2=aes_matrix2_step1;
        state3=aes_matrix3_step1;
        
        if(b) begin
          enc_state=7'b1010101;
        end
        else begin
          enc_state=7'b1010100;
        end
      end
      
      85: begin
        //empty stage, waiting for key 10 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1010110;
        end
        else begin
          enc_state=7'b1010101;
        end
      end
      
      86: begin
        //empty stage, waiting for key 10 to come from key schedule. 
        
        if(b) begin
          enc_state=7'b1010111;
        end
        else begin
          enc_state=7'b1010110;
        end
      end
      
      87: begin
        //empty stage, waiting for key 10 to come from key schedule. 
        //$display("key_out_key_schedule = %h",key_out_key_schedule);
        if(b) begin
          enc_state=7'b1011000;
        end
        else begin
          enc_state=7'b1010111;
        end
      end
      
      88: begin
        //empty stage, waiting for key 10 to come from key schedule. 
        //$display("key_out_key_schedule = %h",key_out_key_schedule);
        if(b) begin
          enc_state=7'b1011001;
        end
        else begin
          enc_state=7'b1011000;
        end
      end
      
      89: begin
        //empty stage, waiting for key 10 to come from key schedule. 
        //$display("key_out_key_schedule = %h",key_out_key_schedule);
        if(b) begin
          enc_state=7'b1011010;
        end
        else begin
          enc_state=7'b1011001;
        end
      end
      
      90: begin
        //Add Round Key operation
		  
		  //$display(" 10 value of key_out_key_schedule = %h",key_out_key_schedule);
        state0[0:7]=state0[0:7] ^ key_out_key_schedule[0:7];
		  state0[8:15]=state0[8:15] ^ key_out_key_schedule[32:39];
		  state0[16:23]=state0[16:23] ^ key_out_key_schedule[64:71];
		  state0[24:31]=state0[24:31] ^ key_out_key_schedule[96:103];
		  
        state1[0:7]=state1[0:7] ^ key_out_key_schedule[8:15];
		  state1[8:15]=state1[8:15] ^ key_out_key_schedule[40:47];
		  state1[16:23]=state1[16:23] ^ key_out_key_schedule[72:79];
		  state1[24:31]=state1[24:31] ^ key_out_key_schedule[104:111];
		  
		  state2[0:7]=state2[0:7] ^ key_out_key_schedule[16:23];
		  state2[8:15]=state2[8:15] ^ key_out_key_schedule[48:55];
		  state2[16:23]=state2[16:23] ^ key_out_key_schedule[80:87];
		  state2[24:31]=state2[24:31] ^ key_out_key_schedule[112:119];
		  
		  state3[0:7]=state3[0:7] ^ key_out_key_schedule[24:31];
		  state3[8:15]=state3[8:15] ^ key_out_key_schedule[56:63];
		  state3[16:23]=state3[16:23] ^ key_out_key_schedule[88:95];
		  state3[24:31]=state3[24:31] ^ key_out_key_schedule[120:127];
		  
		  /*$display("value of 4 state0 = %h",state0);
        $display("value of 4 state1 = %h",state1);
        $display("value of 4 state2 = %h",state2);
        $display("value of 4 state3 = %h",state3);*/
        
		  key_out=key_out_key_schedule;
		  key_store_no=4'b1001;
		  //$display("key_generated @ 1001 i.e..key_10 = %h",key_out_key_schedule);

		  
        //Part 3 over.
        if(b) begin
          enc_state=7'b1011011;
        end
        else begin
          enc_state=7'b1011010;
        end
      end
      
      91: begin
        //Part 4 begins
        
			data_out[0:7]=state0[0:7];
			data_out[32:39]=state0[8:15];
			data_out[64:71]=state0[16:23];
			data_out[96:103]=state0[24:31];
	 
	 
			data_out[8:15]=state1[0:7];
			data_out[40:47]=state1[8:15];
			data_out[72:79]=state1[16:23];
			data_out[104:111]=state1[24:31];
	 
	 
			data_out[16:23]=state2[0:7];
			data_out[48:55]=state2[8:15];
			data_out[80:87]=state2[16:23];
			data_out[112:119]=state2[24:31];
	 
	 
			data_out[24:31]=state3[0:7];
			data_out[56:63]=state3[8:15];
			data_out[88:95]=state3[16:23];
			data_out[120:127]=state3[24:31];
			
			$display("value of encrypted text = %h",data_out);
        
		  //key_no=4'b1010;
		  
        //Part 4 over.
        //$display("data_out = %h",data_out);
        
        if(b) begin
          enc_state=7'b1011100;
        end
        else begin
          enc_state=7'b1011011;
        end

      end
      
      92: begin
      end
      
      default: begin
      end
    endcase
  end
  
end

endmodule