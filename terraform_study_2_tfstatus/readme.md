# 테라폼 스터디 2장

테라폼 스터디 2장에서는 

테라폼의 상태 저장소인 벡엔드에 대해서 알아봅니다.

---

테라폼은 생성한 인프라에 대한 정보를 테라폼 상태 파일에 기록합니다.

기본적으로는 실행한 폴더의 terraform.tfstatus 로 기록합니다.

이는 프라이빗 api로 동작하며 직접 수정해서는 안됩니다.

이러한 벡엔드를 로컬에 저장하게 될 경우 각자마다 상태값이 달라서 문제가 생기게 됩니다.


참고
* 팀단위의 인프라에서는 상태 파일을 공유위치에 저장해야 합니다.
* terraform locking을 통해 다른이가 반영하는 동안 테라폼이 실행되지 않아야 합니다.
* QC, TEST, PROC 단위로 상태파일이 나뉘어져 있어야 합니다.
* 테라폼 설정은 변수값을 받을 수 없습니다. => init때 반영하기 때문

테라폼의 상태는 벡엔드라는 설정을 통해서 어디에 저장할지 위치를 지정할 수 있습니다.

이를 이용하면 아마존의 S3와 같은 저장소에 데이터를 저장할 수 있습니다.

상태 잠금은 aws의 다이나모 DB를 이용해서 지정합니다.

---

원격 벡엔드를 해제하고 리소스를 삭제할 때에는 원격 설정을 제거하고 terraform init을 이용해서 state값을 로컬로 가져옵니다.

그후 terraform destroy를 이용해서 리소스를 제거합니다.

추후에는 배포하는 모듈마다 상태 키값을 지정해서 다른 모듈의 상태를 덮어쓰지 않도록 해야 합니다.

---

벡엔드 설정 분리

벡엔드 설정을 분리하기 위해서는 backend.hcl을 만듭니다.

```
backend.hcl
---------------------------------
bucket = "~~~"
region = "~~~~"
dynamodb_table = "~~~~~"
encrypt = true
```

그후 다음과 같이 명령어를 실행하여 벡엔드 설정을 넣어줍니다.

terraform init -backend-config=backend.hcl

---

분리된 환경 갖추기

테라폼 status 파일을 분리 보관하여 환경별로 상태값을 따로 보관할 수 있습니다.

이는 작업 공간을 통한 격리(테스트 환경에 유용), 파일 레이아웃을 통한 격리(실제 운영에 적합)하는 방법이 있습니다.

---

작업 공간을 통한 격리

테라폼은 기본적으로 default 워크스페이스에서 기본 작업 공간을 가집니다. 이러한 작업 공간을 전환하는 방법은 

```
terrafrom workspace [ show | new | select ] [workspacename]
```

명령을 이용합니다.

이러한 워크스페이스를 만들면 s3에 env: 라는 데이터가 있음을 확인할 수 있습니다.

즉 다른 작업 공간으로 전환하는 것은 상태파일이 저장된 경로를 변경하는 것과 같습니다.

이는 새로운 모듈을 테스트하기에 적합합니다.

이는 같은 인증을 하기 때문에 환경을 분리하는 데에는 적합하지 않습니다.