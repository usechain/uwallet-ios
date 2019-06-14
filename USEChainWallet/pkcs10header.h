//
//  header.h
//  USEChainWallet
//
//  Created by Jacob on 2019/3/5.
//  Copyright © 2019 Jacob. All rights reserved.
//

#ifndef pkcs10header_h
#define pkcs10header_h

#include <stdio.h>

#endif /* header_h */

#include <openssl/x509.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <string.h>
//**在这里需要声明函数**/
X509_NAME *parse_name(char *subject, long chtype, int multirdn);
X509_NAME *CreateDN(char *pbEmail, char *pbCN, char *pbOU, char *pbO, char *pbL, char *pbST, char *pbC);
long int GenCSR(char *pbDN, int nDNLen, char *pCSR, size_t nCSRSize, char *privateKey);

//#include <stdio.h>
//
//
//
//
//#include <openssl/x509.h>
//#include <openssl/rsa.h>
//#include <openssl/pem.h>
//#include <string.h>
////**在这里需要声明函数**/
//// 传入的信息参数，字符串形式一次传入，不传也可以
//X509_NAME *parse_name(char *subject, long chtype, int multirdn);
//// 传入信息参数，分内容对应传入
//X509_NAME *CreateDN(char *pbEmail, char *pbCN, char *pbOU, char *pbO, char *pbL, char *pbST, char *pbC);


