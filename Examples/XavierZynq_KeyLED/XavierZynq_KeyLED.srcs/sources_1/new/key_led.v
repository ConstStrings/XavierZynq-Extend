module key_led(
    input sys_clk,
    input sys_rst,  // 添加复位信号
    input key,
    output [2:0] led
);

    // 参数定义 (假设50MHz时钟)
    parameter DEBOUNCE_TIME = 2_500_000; // 50ms消抖时间
    
    // 内部信号
    reg [31:0] debounce_cnt;  // 调整位宽以匹配计数范围
    reg key_reg1, key_reg2, key_reg3;
    reg key_pressed;
    reg [2:0] led_reg;

    // 按键同步 (三级同步更稳定)
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst) begin
            key_reg1 <= 1'b1;
            key_reg2 <= 1'b1;
            key_reg3 <= 1'b1;
        end
        else begin
            key_reg1 <= key;
            key_reg2 <= key_reg1;
            key_reg3 <= key_reg2;
        end
    end

    // 下降沿检测
    wire key_neg = key_reg3 & (~key_reg2);

    // 上升沿检测
    wire key_pos = (~key_reg3) & key_reg2;

    localparam IDLE = 2'b00;
    localparam DEBOUNCE = 2'b01;

    reg state;

    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst) begin
            state <= IDLE;
            key_pressed <= 1'b0;
            debounce_cnt <= 32'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (key_neg) begin
                        state <= DEBOUNCE;
                        debounce_cnt <= 32'd0;
                    end
                    key_pressed <= 1'b0;
                end
                DEBOUNCE: begin
                    debounce_cnt <= debounce_cnt + 1;
                    if (key_pos) begin
                        if (debounce_cnt > DEBOUNCE_TIME) begin
                            key_pressed <= 1'b1;  
                        end
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end


    // LED移位控制
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            led_reg <= 3'b110;  // 复位时初始化
        else if (key_pressed)
            led_reg <= {led_reg[1:0], led_reg[2]};  // 循环左移
    end

    assign led = led_reg;

endmodule