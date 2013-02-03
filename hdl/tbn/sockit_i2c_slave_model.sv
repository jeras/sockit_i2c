module sockit_i2c_slave_model #(
  parameter string MODE = "100kHz"
)(
  inout wire scl,  // serial clock
  inout wire sda   // serial data
);

logic scl_o, scl_e;
logic sda_o, sda_e;

bufif1 buf_scl (scl , scl_o, scl_e); 
bufif1 buf_sda (sda , sda_o, sda_e); 

// delay variables initialized to delay parameters
real t_unit = 10ns;

// after power-up, put the master into an idle state
initial
begin
  scl_e = 1'b0;
  sda_e = 1'b0;
  scl_o = 1'b0;
  sda_o = 1'b0;

  // loop
  forever
  begin
    @ (negedge sda);
    for (int b=7; b>0; b--) begin
      @ (negedge scl);
    end
    sda_e = 1'b1;
    @ (negedge scl);
    sda_e = 1'b0;
  end
end

endmodule : sockit_i2c_slave_model
