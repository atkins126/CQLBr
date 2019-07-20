unit test.select;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestCQLSelect = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestSelectAll;
    [Test]
    procedure TestSelectAllNoSQL;
    [Test]
    procedure TestSelectAllWhere;
    [Test]
    procedure TestSelectAllOrderBy;
    [Test]
    procedure TestSelectColumns;
    [Test]
    procedure TestSelectColumnsCase;
    [Test]
    procedure TestSelectPagingFirebird;
    [Test]
    procedure TestSelectPagingOracle;
    [Test]
    procedure TestSelectPagingMySQL;
  end;

implementation

uses
  SysUtils,
  cqlbr.interfaces,
  criteria.query.language;

procedure TTestCQLSelect.Setup;
begin
end;

procedure TTestCQLSelect.TearDown;
begin
end;

procedure TTestCQLSelect.TestSelectAll;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES AS CLI';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES').&As('CLI')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectAllNoSQL;
var
  LAsString: String;
begin
  LAsString := 'clientes.Find( {} )';
  Assert.AreEqual(LAsString, TCQL.New(dbnMongoDB)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectAllOrderBy;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES ORDER BY ID_CLIENTE';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .OrderBy('ID_CLIENTE')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectAllWhere;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE ID_CLIENTE = 1';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .Where('ID_CLIENTE = 1')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectColumns;
var
  LAsString: String;
begin
  LAsString := 'SELECT ID_CLIENTE, NOME_CLIENTE FROM CLIENTES';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .Column('ID_CLIENTE')
                                      .Column('NOME_CLIENTE')
                                      .From('CLIENTES')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectColumnsCase;
var
  LAsString: String;
begin
  LAsString := 'SELECT ID_CLIENTE, NOME_CLIENTE, (CASE TIPO_CLIENTE WHEN 0 THEN ''FISICA'' WHEN 1 THEN ''JURIDICA'' ELSE ''PRODUTOR'' END) AS TIPO_PESSOA FROM CLIENTES';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .Column('ID_CLIENTE')
                                      .Column('NOME_CLIENTE')
                                      .Column('TIPO_CLIENTE')
                                      .&Case
                                        .When('0').&Then('''FISICA''')
                                        .When('1').&Then('''JURIDICA''')
                                                  .&Else('''PRODUTOR''')
                                      .&End
                                      .&As('TIPO_PESSOA')
                                      .From('CLIENTES')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectPagingFirebird;
var
  LAsString: String;
begin
  LAsString := 'SELECT FIRST 3 SKIP 0 * FROM CLIENTES AS CLI ORDER BY CLI.ID_CLIENTE';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .First(3).Skip(0)
                                      .From('CLIENTES', 'CLI')
                                      .OrderBy('CLI.ID_CLIENTE')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectPagingMySQL;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES ORDER BY ID_CLIENTE LIMIT 3 OFFSET 0';
  Assert.AreEqual(LAsString, TCQL.New(dbnMySQL)
                                      .Select
                                      .All
                                      .Limit(3).Offset(0)
                                      .From('CLIENTES')
                                      .OrderBy('ID_CLIENTE')
                                      .AsString);
end;

procedure TTestCQLSelect.TestSelectPagingOracle;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM (SELECT T.*, ROWNUM AS ROWINI FROM (SELECT * FROM CLIENTES ORDER BY ID_CLIENTE) T) WHERE ROWNUM <= 3 AND ROWINI > 0';
  Assert.AreEqual(LAsString, TCQL.New(dbnOracle)
                                      .Select
                                      .All
                                      .Limit(3).Offset(0)
                                      .From('CLIENTES')
                                      .OrderBy('ID_CLIENTE')
                                      .AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCQLSelect);

end.