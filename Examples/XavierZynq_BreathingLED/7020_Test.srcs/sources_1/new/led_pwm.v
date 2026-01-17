`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 19:18:46
// Design Name: 
// Module Name: led_pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_pwm(
    input  wire                         clk                        ,
    input  wire                         rst_n                      ,
    output wire                         led                         
    );

reg                    [  19:0]         cnt_10ms                   ;
reg                    [   7:0]         cnt_2s                     ;
reg                                     count_mode                 ;
reg                                     pwm_value                  ;
reg                                     cnt_10ms_clp_flag          ;

assign led = ~pwm_value;

//-------------Parameters--------------
    parameter                           CNT_10MS_MAX = 500000 - 1  ;
    parameter                           CNT_2S_MAX = 200 - 1       ;
    parameter                           pwm_factor = 5000          ;

//-------------Timer_10ms--------------
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        cnt_10ms <= 'd0;
        cnt_10ms_clp_flag <= 1'b0;
    end

    else if (cnt_10ms == CNT_10MS_MAX) begin
        cnt_10ms <= 'd0;
        cnt_10ms_clp_flag <= 1'b1;
    end

    else begin
        cnt_10ms <= cnt_10ms + 1'b1;
        cnt_10ms_clp_flag <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        cnt_2s <= 'd0;
        count_mode <= 1'b0;
    end

    else begin
        if (cnt_2s == 7'b1100100) begin
            count_mode <= 1;
        end

        else begin
            count_mode <= count_mode;
        end

        if (cnt_2s == CNT_2S_MAX) begin
            cnt_2s <= 'd0;
            count_mode <= 0;
        end

        else if (cnt_10ms_clp_flag == 1'b1) begin
            cnt_2s <= cnt_2s + 1'b1;
        end
        
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        pwm_value <= 1'b0;
    end

    else if (count_mode == 1'b0) begin
        if (cnt_2s * pwm_factor > cnt_10ms) begin
            pwm_value = 1'b1;
        end

        else begin
            pwm_value = 1'b0;
        end
    end

    else begin
        if ((200 - cnt_2s) * pwm_factor > cnt_10ms) begin
            pwm_value = 1'b1;
        end

        else begin
            pwm_value = 1'b0;
        end
    end
end

ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(pwm_value) // input wire [0:0] probe0
);


endmodule
