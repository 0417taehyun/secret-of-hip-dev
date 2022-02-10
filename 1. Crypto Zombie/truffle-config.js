/*
솔리디티는 EVM(Ethereum Virtual Machine) 위에서 작동한다.
이를 위해서는 소스 코드를 Bytecode로 컴파일 해야하며 Truffle을 사용하여 컴파일을 할 수 있다.

그리고 아래는 컴파일 및 배포할 때 적용되는 설정을 작성하는 부분이다.
truffle-config.js 파일의 내용을 읽어서 설정을 적용한다.
*/

module.exports = {
  // 현재 dApp의 네트워크 환경을 정의하는 부분이다.
  networks: {
    // development는 개발용으로 이 외에도 Ropsten, private 등이 존재한다.
    development: {
      host: "127.0.0.1",
      port: 7545, // 표준 이더리움 포트 번호다.
      network_id: "*", // 이더리움 네트워크 고유 아이디를 의미하며 사설 네트워크를 사용하기 위해 애스터리스크(*) 값을 사용한다.
    },
  },

  compilers: {
    solc: {
      version: "0.8.11",
    },
  },
};
