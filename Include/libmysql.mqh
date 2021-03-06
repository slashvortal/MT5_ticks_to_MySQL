//+------------------------------------------------------------------+
//|                                                     libmysql.mqh |
//|                                                        avoitenko |
//|                        https://login.mql5.com/ru/users/avoitenko |
//+------------------------------------------------------------------+
#property copyright "avoitenko"
#property link      "https://login.mql5.com/ru/users/avoitenko"

//+------------------------------------------------------------------+
//|   #import                                                        |
//+------------------------------------------------------------------+
/*
#import  "libmysql.dll" // версия 6.0.2
int      mysql_init(int db);
string   mysql_get_server_info(int TMYSQL);
int      mysql_errno(int TMYSQL);
string   mysql_error(int TMYSQL);
int      mysql_real_connect(int TMYSQL, string host, string user, string password, string DB,int port,int socket,int clientflag);
int      mysql_real_query(int TMSQL, string query, int length);
int      mysql_store_result(int TMSQL); 
string   mysql_fetch_row(int result); 
int      mysql_num_rows(int result); 
void     mysql_free_result(int result);
void     mysql_close(int TMSQL);
#import  "user32.dll"
int      GetAncestor(int hwnd, int gaFlags);
int      SendMessageA(int hWnd, int Msg, int wParam, int lParam);
int      SetWindowLongA(int hWnd, int Index, int lParam);
#import "kernel32.dll"
int      GetFileAttributesA(string lpFileName);
#import
*/
//+------------------------------------------------------------------+
//|                                   Championship_MySQL_Connect.mqh |
//|                                                        avoitenko |
//|                        https://login.mql5.com/ru/users/avoitenko |
//+------------------------------------------------------------------+
#property copyright     ""
#property link          "https://login.mql5.com/ru/users/avoitenko" // Редактор

#property description "MySQL Connect"
#property version "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//| Внешние переменные                                               |
//+------------------------------------------------------------------+
input string HOST       =  "81.222.215.235"; // IP address
input ushort PORT       =  3306;             // Port
input string USER       =  "studiafn_datab"; // Login
input string PASSWORD   =  "ghtlctlfntkm";   // Password
input string DB_NAME    =  "studiafn_datab"; // Database name
input ushort CON_TIMEOUT=30;          // Connection timeout
*/
//+------------------------------------------------------------------+
//|   mysql_option                                                   |
//+------------------------------------------------------------------+
enum mysql_option
  {
   MYSQL_OPT_CONNECT_TIMEOUT,MYSQL_OPT_COMPRESS,MYSQL_OPT_NAMED_PIPE,MYSQL_INIT_COMMAND,
   MYSQL_READ_DEFAULT_FILE,MYSQL_READ_DEFAULT_GROUP,MYSQL_SET_CHARSET_DIR,MYSQL_SET_CHARSET_NAME,
   MYSQL_OPT_LOCAL_INFILE,MYSQL_OPT_PROTOCOL,MYSQL_SHARED_MEMORY_BASE_NAME,MYSQL_OPT_READ_TIMEOUT,
   MYSQL_OPT_WRITE_TIMEOUT,MYSQL_OPT_USE_RESULT,MYSQL_OPT_USE_REMOTE_CONNECTION,MYSQL_OPT_USE_EMBEDDED_CONNECTION,
   MYSQL_OPT_GUESS_CONNECTION,MYSQL_SET_CLIENT_IP,MYSQL_SECURE_AUTH,MYSQL_REPORT_DATA_TRUNCATION,
   MYSQL_OPT_RECONNECT,MYSQL_OPT_SSL_VERIFY_SERVER_CERT,MYSQL_PLUGIN_DIR,MYSQL_DEFAULT_AUTH
  };

#ifdef __MQL5__
#define POINTER   long
#else
#define POINTER   int
#endif
#define MYSQL     POINTER
#define MYSQL_RES POINTER

//+------------------------------------------------------------------+
//| Импорт функций                                                   |
//+------------------------------------------------------------------+

#import "libmysql.dll"
MYSQL mysql_init(MYSQL mysql);
void mysql_close(MYSQL mysql);
MYSQL mysql_real_connect(MYSQL mysql,char &host[],
                         char &user[],char &passwd[],
                         char &db[],uint port,char &unix_socket[],
                         ulong clientflag);

POINTER mysql_error(MYSQL mysql);
uint mysql_errno(MYSQL mysql);
int mysql_query(MYSQL mysql,char &stmt_str[]);
int mysql_real_query(MYSQL mysql,char &stmt_str[],ulong length);

MYSQL_RES mysql_store_result(MYSQL mysql);
MYSQL_RES mysql_field_count(MYSQL mysql);
int mysql_num_rows(MYSQL_RES result);
int mysql_fetch_row(MYSQL_RES result);
void mysql_free_result(MYSQL_RES result);

int mysql_options(MYSQL mysql,mysql_option option,char &arg[]);

long mysql_get_server_version(MYSQL mysql);
POINTER mysql_get_host_info(MYSQL mysql);
POINTER mysql_get_server_info(MYSQL mysql);

//int mysql_character_set_name(int mysql);
//int mysql_stat(int mysql);
int mysql_ping(MYSQL mysql);

#import "msvcrt.dll"
int strcpy(uchar &dst[],POINTER src);
int memcpy(double &dst[],double &src[],int cnt);
int memcpy(int &dst[],int &src[],int cnt);
#import
//+------------------------------------------------------------------+
//|   MYSQL_STATUS                                                   |
//+------------------------------------------------------------------+
enum ENUM_MYSQL_STATUS
  {
   STATUS_OK,
   STATUS_NOT_INIT,
   STATUS_NOT_CONNECTED,
   STATUS_BAD_REQUEST
  };
//+------------------------------------------------------------------+
//|   MYSQL_VER                                                      |
//+------------------------------------------------------------------+
struct MYSQL_VER
  {
   uchar             major_version;
   uchar             minor_version;
   uchar             sub_version;
  };

#define STR_LEN 300
//+------------------------------------------------------------------+
//|   Класс CMySQL_Connection_Connection                                        |
//+------------------------------------------------------------------+
class CMySQL_Connection
  {
private:
   bool              connect;
   MYSQL             mysql;
   MYSQL_VER         ver;

   uint              error_code;
   string            error_desc;

   uchar             mystr[STR_LEN];
   uchar             myres[152];
   long              m_tag;

   void              UpdateErrorInfo(const int code=WRONG_VALUE);
public:
   //+------------------------------------------------------------------+
   long              Tag(){return m_tag;}

   //+------------------------------------------------------------------+
   void              Tag(const long value){m_tag=value;}

   //+------------------------------------------------------------------+
                     CMySQL_Connection()
     {
      connect=false;
      m_tag=0;
     }

   //+------------------------------------------------------------------+
                    ~CMySQL_Connection()
     {
      Close();
     }

   //+------------------------------------------------------------------+
   bool              Init();

   //+------------------------------------------------------------------+
   void              Close();

   //+------------------------------------------------------------------+
   ENUM_MYSQL_STATUS GetStatus();

   //+------------------------------------------------------------------+
   bool              Connect(const string host,const uint port,const string db,const string user,const string passwd,const string unix_socket,const int client_flag);

   //+------------------------------------------------------------------+
   uint            GetLastError(){return(error_code);}

   //+------------------------------------------------------------------+
   string          GetErrorDescription()
     {

      return(error_desc);
     }

   //+------------------------------------------------------------------+
   MYSQL_VER         GetServerVersion();

   //+------------------------------------------------------------------+
   string            GetServerVersionString();

   //+------------------------------------------------------------------+
   string            GetServerInfo();

   //+------------------------------------------------------------------+
   string            GetHostInfo();

   //+------------------------------------------------------------------+
   ENUM_MYSQL_STATUS ExecSQL(string sql);

   //+------------------------------------------------------------------+
   ENUM_MYSQL_STATUS ExecRequest(string sql,double &result);
  };
//+------------------------------------------------------------------+
ENUM_MYSQL_STATUS CMySQL_Connection::ExecRequest(string sql,double &result)
  {
   result=0;

   ENUM_MYSQL_STATUS status=GetStatus();

//--- проверка соединения
   if(status!=STATUS_OK)
      return(status);

//---
   uchar query[];
   StringToCharArray(sql,query);

//---
   int res=mysql_real_query(mysql,query,StringLen(sql));
   if(res!=0)
     {
      UpdateErrorInfo();
      return(false);
     }

//---
   MYSQL_RES res2=mysql_store_result(mysql);
   if(res!=0)
     {
      if(mysql_field_count(mysql)>0 && mysql_num_rows(res2)>0)
        {
         int row=mysql_fetch_row(res2);

         uchar str[10];
         strcpy(str,row);

         //--- адрес
         int value=(int)((uint)str[0]+(uint)str[1]*MathPow(2,8)+(uint)str[2]*MathPow(2,16)+(uint)str[3]*MathPow(2,24));
         strcpy(str,value);

         result=StringToDouble(CharArrayToString(str));

         mysql_free_result(res);
         return(true);
        }

      mysql_free_result(res);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//|   ExecSQL()                                                      |
//+------------------------------------------------------------------+
ENUM_MYSQL_STATUS CMySQL_Connection::ExecSQL(const string sql)
  {
////--- проверка соединения
   ENUM_MYSQL_STATUS status=GetStatus();
   if(status!=STATUS_OK)
      return(status);

   uchar query[];
   StringToCharArray(sql,query);

   int res=mysql_query(mysql,query);
   if(res!=0)
     {
      UpdateErrorInfo();
      return(STATUS_BAD_REQUEST);
     }

   UpdateErrorInfo(0);
   return(STATUS_OK);
  }
//+------------------------------------------------------------------+
//|   GetError() - получение строки описания ошибки                  |
//+------------------------------------------------------------------+
void CMySQL_Connection::UpdateErrorInfo(const int code=WRONG_VALUE)
  {
   if(code==0)
     {
      error_code=0;
      error_desc="";
      return;
     }
//---
   error_code=mysql_errno(mysql);
   MYSQL ptr=mysql_error(mysql);
   if(ptr>0)
     {
      uchar str[];
      ArrayResize(str,STR_LEN);
      strcpy(str,ptr);
      error_desc=CharArrayToString(str);
     }
   else Print("Error mysql_error");
  }
//+------------------------------------------------------------------+
//|   Init()                                                         |
//+------------------------------------------------------------------+
bool CMySQL_Connection::Init()
  {
//--- закрыть предыдущее соединение   
   Close();
//---
   mysql=mysql_init(mysql);
   if(mysql==0)
     {
      UpdateErrorInfo();
      return(false);
     }
//---
   UpdateErrorInfo(0);
   return(true);
  }
//+------------------------------------------------------------------+
//|   Deinit()                                                       |
//+------------------------------------------------------------------+
void CMySQL_Connection::Close()
  {
   mysql_close(mysql);
   mysql=0;
   connect=false;
  }
//+------------------------------------------------------------------+
//|   Connect()                                                      |
//+------------------------------------------------------------------+
bool CMySQL_Connection::Connect(const string host,
                                const uint port,
                                const string db,
                                const string user,
                                const string passwd,
                                const string unix_socket,
                                const int client_flag)
  {

   uchar a_host[];
   uchar a_user[];
   uchar a_passwd[];
   uchar a_db[];
   uchar a_unix_socket[];

   StringToCharArray(host,a_host);
   StringToCharArray(user,a_user);
   StringToCharArray(passwd,a_passwd);
   StringToCharArray(db,a_db);
   StringToCharArray(unix_socket,a_unix_socket);

//---
   mysql=mysql_init(mysql);
   MYSQL res=mysql_real_connect(mysql,a_host,a_user,a_passwd,a_db,port,a_unix_socket,client_flag);
   if(res==0)
     {
      UpdateErrorInfo();
      connect=false;
     }
   else
     {
      UpdateErrorInfo(0);
      connect=true;
     }
//---
   return(connect);
  }
//+------------------------------------------------------------------+
//|   Status()                                                       |
//+------------------------------------------------------------------+
ENUM_MYSQL_STATUS CMySQL_Connection::GetStatus()
  {
   if(mysql==0)
     {
      return(STATUS_NOT_INIT);
     }
//---
   if(!connect)
      return(STATUS_NOT_CONNECTED);

//--- ping
   if(mysql_ping(mysql)!=0)
      return(STATUS_NOT_CONNECTED);

   return(STATUS_OK);
/*
   uchar query[10];
   StringToCharArray("SELECT 1;",query);

   int res=mysql_query(mysql,query);
   int mysqlres=mysql_store_result(mysql);
   mysql_free_result(mysqlres);

   if(res==0) return(CONNECTION_OK);
   else return(CONNECTION_BAD);
   */

  }
//+------------------------------------------------------------------+
//|   GetServerVersion()                                             |
//+------------------------------------------------------------------+
MYSQL_VER CMySQL_Connection::GetServerVersion()
  {
   ZeroMemory(ver);
   if(!connect)return(ver);
//---
   long res=mysql_get_server_version(mysql);
   if(res!=0)
     {
      ver.major_version = (uchar)(res/10000);
      ver.minor_version = (uchar)((res - ver.major_version*10000)/100);
      ver.sub_version   = (uchar)(res - ver.major_version*10000 - ver.minor_version*100);
     }
   else
      UpdateErrorInfo();
//---
   return(ver);
  }
//+------------------------------------------------------------------+
//|   GetServerVersionString ()                                      |
//+------------------------------------------------------------------+
string CMySQL_Connection::GetServerVersionString()
  {
   GetServerVersion();
   return(StringFormat("%i.%i.%i",ver.major_version,ver.minor_version,ver.sub_version));
  }
//+------------------------------------------------------------------+
//|   GetServerInfo()                                                |
//+------------------------------------------------------------------+
string CMySQL_Connection::GetServerInfo()
  {
   ZeroMemory(mystr);
   if(!connect)
      return("");
//---
   long ptr=mysql_get_server_info(mysql);
   if(ptr!=0)
      strcpy(mystr,ptr);
//---
   return(CharArrayToString(mystr));
  }
//+------------------------------------------------------------------+
//|   GetHostInfo()                                                  |
//+------------------------------------------------------------------+
string CMySQL_Connection::GetHostInfo()
  {
   ZeroMemory(mystr);
   if(!connect) return("");
//---
   POINTER ptr=mysql_get_host_info(mysql);
   if(ptr!=0)
      strcpy(mystr,ptr);
//---      
   return(CharArrayToString(mystr));
  }
//+------------------------------------------------------------------+
