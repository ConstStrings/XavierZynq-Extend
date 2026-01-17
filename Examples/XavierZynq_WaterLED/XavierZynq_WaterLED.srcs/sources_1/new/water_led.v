`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/17 22:10:03
// Design Name: 
// Module Name: water_led
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


module water_led(
    input sys_clk,
    input rst_n,
    output [2:0] led
    );

    reg [25:0] cnt;
    reg [2:0] led_reg;

    parameter CNT_MAX = 26'd25_000_000;

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 26'd0;
        else if (cnt >= CNT_MAX - 1)
            cnt <= 26'd0;
        else
            cnt <= cnt + 1'b1;
    end

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            led_reg <= 3'b011;
        else if (cnt == CNT_MAX - 1) begin
            led_reg <= {led_reg[1:0], led_reg[2]};
        end
    end

    assign led = led_reg;

endmodule
