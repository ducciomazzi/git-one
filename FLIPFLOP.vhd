library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FLIPFLOP is
port(
CK: in std_logic;
RN: in std_logic;
WR: in std_logic;
RD: out std_logic;
RDN: out std_logic);
end FLIPFLOP;

architecture behavior of FLIPFLOP is


begin

  InOutP: process( CK, RN )
  variable QTemp : std_logic;
  begin
    if RN = '0' then
      QTemp:='0';
    elsif CK'event and CK='1' then
        QTemp := WR;
    end if;
    RD <= QTemp;
    RDN <= not(QTemp);
  end process;

end behavior;
