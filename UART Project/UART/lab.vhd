library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity lab is
    Port ( clk,rst, rx : in  STD_LOGIC;    -- rst är tryckknappen i mitten under displayen
           seg: out  UNSIGNED(7 downto 0);
           an : out  UNSIGNED (3 downto 0));
end lab;

architecture Behavioral of lab is

  component leddriver
    Port ( clk,rst : in  STD_LOGIC;
           seg : out  UNSIGNED(7 downto 0);
           an : out  UNSIGNED (3 downto 0);
           value : in  UNSIGNED (15 downto 0));
  end component;

    signal sreg : UNSIGNED(9 downto 0) := B"0_00000000_0";  -- 10 bit skiftregister
    signal tal : UNSIGNED(15 downto 0) := X"0000";  
    signal rx1,rx2 : std_logic;         -- vippor på insignalen
    signal sp, q_sp, q_sp_plus, x_sp : std_logic;              -- skiftpuls
    signal lp, q_lp, q_lp_plus, x_lp : std_logic;              -- laddpuls
    signal pos : UNSIGNED(1 downto 0) := "00";
    signal clk_counter : UNSIGNED(9 downto 0) := "0000000000";
    signal sp_counter : UNSIGNED(3 downto 0) := "0000";
    signal count_clk : std_logic;

  begin
  -- Synchronizing flip-flops
  -- Using one process
  process(clk)
  begin
    if rising_edge(clk) then
      rx2 <= rx1;
      rx1 <= rx;
    end if;
  end process;  

  -- *****************************
  -- *       styrenhet           *
  -- *****************************

-- Enpulsning

process(clk) begin
  if rising_edge(clk) then
    if (rx1 = '0' and rx2 = '1') then
      count_clk <= '1';
      clk_counter <= "0000000000";
      x_sp <= '1';
    elsif count_clk = '1' then
      clk_counter <= clk_counter + 1;
    end if;
    if clk_counter = 434 then 
      x_sp <= '1';
      sp_counter <= sp_counter + 1;
    elsif clk_counter = 868 then
      clk_counter <= "0000000000";
    else
      x_sp <= '0';
    end if;
    
    if sp_counter = 10 then 
      x_lp <= '1';
      sp_counter <= "0000";
      count_clk <= '0';
    else
      x_lp <= '0';
    end if;
  end if;
end process;


  --Enpulsning
  process(clk) begin
    if rising_edge(clk) then
      q_sp <= q_sp_plus;
      q_lp <= q_lp_plus;
    end if;
  end process;

  q_sp_plus <= x_sp; -- q+ = f(q,x)
  sp <= (not q_sp) and x_sp; 

  q_lp_plus <= x_lp; -- q+ = f(q,x)
  lp <= (not q_lp) and x_lp; 

  -- *****************************
  -- * 10 bit skiftregister      *
  -- *****************************
  process(clk)
  begin
    if rising_edge(clk) then
      if sp = '1' then
        sreg <= rx2 & sreg(9 downto 1); -- this is done because rx2 is only 1 bit and sreg is 10 bit
      end if;
    end if;
  end process;

  
  -- *****************************
  -- * 2  bit register           *
  -- *****************************
  -- A process that implements a simple 2-bit register that increments its value on every rising edge of the 
  -- clock signal, if the sp signal is '1', and resets to "00" when rst is '1'.
  process(clk)  
  -- Tror at det ska vara lp istället för sp --
  begin
    if rst = '1' then
      pos <= "00";
    elsif rising_edge(clk) then
      if lp = '1' then 
        pos <= pos + 1;
      end if;
    end if;
  end process;
      

  
  -- *****************************
  -- * 16 bit register           *
  -- *****************************
  -- process block that implements a control logic for assigning values to a target register, 'tal'
  process(clk)
  begin
    if rising_edge(clk) then
      if lp = '1' then
        if pos = 0 then -- rx1 måste vara aktiv annars sker det en bugg med pos
          tal(15 downto 12) <= sreg(4 downto 1);
        elsif pos = 1 then
          tal(11 downto 8) <= sreg(4 downto 1);
        elsif pos = 2 then
          tal(7 downto 4) <= sreg(4 downto 1);
        elsif pos = 3 then
          tal(3 downto 0) <= sreg(4 downto 1);
        end if;
      end if;
    end if;
  end process;
  
  
  -- *****************************
  -- * Multiplexad display       *
  -- *****************************

  -- Inkoppling av komponenten leddriver
  led: leddriver port map (clk, rst, seg, an, tal);
end Behavioral;

