// Code your testbench here
// or browse Examples
package helpers;

function automatic logic MIN( input logic A, input logic B );
    if ( A < B )
        return( A );
    else
        return( B );
endfunction

typedef bit [ 31:0 ] uint32_t;
typedef enum { FAIL, PASS } pf_e;

endpackage

// ========================================================================

interface toggle_sync_if
(
    input bit clka,
    input bit clkb
);

    logic rsta_n = 1;
    logic rstb_n = 1;
    logic pulse_in = 0;
    logic pulse_out;

    clocking cba @( posedge clka );
        default output #0.1;

        output rsta_n;
        output pulse_in;
    endclocking : cba

    clocking cbb @( posedge clkb );
        default output #0.1;

        output rstb_n;
        input pulse_out;
    endclocking : cbb

    modport TB_A( clocking cba );
    modport TB_B( clocking cbb );

endinterface : toggle_sync_if

// ========================================================================

module tb;

logic clka;
logic clkb;

toggle_sync_if u_toggle_sync_if
(
    .clka( clka ),
    .clkb( clkb )
);

// instantiate the main program (test)
main_prg u_main_prg( .i_f( u_toggle_sync_if ) );

initial
begin
    $dumpfile( "dump.vcd" );
    $dumpvars( 0 );
end
  
initial
begin
    $timeformat( -9, 1, "ns", 8 );
    
    fork
    begin
        clka = 1'b0;
        forever #5 clka = ~clka;
    end
    
    begin
        clkb = 1'b0;
        forever #6 clkb = ~clkb;
    end
    join_none
end
  
toggle_sync u_toggle_sync
(
    .clka( clka ),
    .rsta_n( u_toggle_sync_if.rsta_n ),

    .clkb( clkb ),
    .rstb_n( u_toggle_sync_if.rstb_n ),

    .pulse_in( u_toggle_sync_if.pulse_in ),
    .pulse_out( u_toggle_sync_if.pulse_out )
);

endmodule

// ========================================================================

program automatic main_prg( toggle_sync_if i_f );

virtual toggle_sync_if.TB_A siga_h = i_f.TB_A;
virtual toggle_sync_if.TB_B sigb_h = i_f.TB_B;

initial
begin

    fork
    begin
        siga_h.cba.rsta_n <= 1'b0;
        #50 siga_h.cba.rsta_n <= 1'b1;
    end

    begin
        sigb_h.cbb.rstb_n <= 1'b0;
        #50 sigb_h.cbb.rstb_n <= 1'b1;
    end
    join

    repeat( 2000 ) @( siga_h.cba );
end

endprogram
