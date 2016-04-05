`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:35 11/01/2015 
// Design Name: 
// Module Name:    aes_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module aes_top(
    input clk,rst_enc,rst_dec,
    input [0:127] plain_data,key_input,
    output [0:127]decrypted_data,
    output reg data_match
    );

//wire [0:127]cipher_data;
//wire [0:3]key_no;
//wire [0:127]key_value_store; 
//reg encrypted_data

wire [0:127]cipher_data,key_from_enc;
wire [0:3]key_store_no;
wire [0:3]key_extract_no;
reg [0:127]key_to_dec;
reg [0:127]key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;
wire [0:7]dynamic_s_box_wire;
reg [0:7]dynamic_s_box_reg;

aes_enc z1 (clk,rst_enc,plain_data,key_input,cipher_data,key_from_enc,key_store_no,dynamic_s_box_wire);
//memory_key z2 (key_no,key_value_store);
aes_dec z2 (clk,rst_dec,cipher_data,key_to_dec,key_extract_no,decrypted_data,dynamic_s_box_reg);

always @ (posedge clk) begin
	if(rst_enc==1'b0)begin
	case (key_store_no)
		0: begin
			key_1=key_from_enc;
			//$display("input key = %h",key_input);
			//$display("key_1 = %h",key_1);
		end
		1: begin
			key_2=key_from_enc;
			//$display("key_2 = %h",key_2);
		end
		2: begin
			key_3=key_from_enc;
			//$display("key_3 = %h",key_3);
		end
		3: begin
			key_4=key_from_enc;
			//$display("key_4 = %h",key_4);
		end
		4: begin
			key_5=key_from_enc;
			//$display("key_5 = %h",key_5);
		end
		5: begin
			key_6=key_from_enc;
			//$display("key_6 = %h",key_6);
		end
		6: begin
			key_7=key_from_enc;
			//$display("key_7 = %h",key_7);
		end
		7: begin
			key_8=key_from_enc;
			//$display("key_8 = %h",key_8);
		end
		8: begin
			key_9=key_from_enc;
			//$display("key_9 = %h",key_9);
		end
		9: begin
			key_10=key_from_enc;
			//$display("key_10 = %h",key_10);
		end
	endcase
	end
	
	/*else if(rst_dec==1'b1) begin
	key_extract_no=4'b0000;
	end*/
	
	if(rst_dec==1'b0) begin
		dynamic_s_box_reg=dynamic_s_box_wire;
	//$display("rst == 0 reached and rst_dec=%h",rst_dec);
		case (key_extract_no)
		0:begin
			key_to_dec=key_10;
			//$display("key_10 = %h",key_10);
			//$display("key_to_dec @ key_extract_no==0 is = %h",key_to_dec);
		end
		1: begin
			key_to_dec=key_9;
			//$display("key_to_dec @ key_extract_no==1 is = %h",key_to_dec);
		end
		2: begin
			key_to_dec=key_8;
		end
		3: begin
			key_to_dec=key_7;
		end
		4: begin
			key_to_dec=key_6;
		end
		5: begin
			key_to_dec=key_5;
		end
		6: begin
			key_to_dec=key_4;
		end
		7: begin
			key_to_dec=key_3;
		end
		8: begin
			key_to_dec=key_2;
		end
		9: begin
			key_to_dec=key_1;
		end
		10:begin
			key_to_dec=key_input;
		end
		endcase
	end
	
	if(decrypted_data==plain_data) begin
		data_match=1'b1;
	end
end


endmodule
