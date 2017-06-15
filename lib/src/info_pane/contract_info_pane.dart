import 'package:angular2/core.dart';

import 'package:contracts/contract_general_model.dart';
import 'package:contracts/contracts_service.dart';
import 'package:angular_utils/pipes.dart';
import 'package:angular_utils/directives.dart';

@Component(
    selector: 'contract-info-pane',
    providers: const [ContractsService],
    templateUrl: 'contract_info_pane.html',
    pipes: const [CmFormatMoneyPipe],
    directives: const [CmLoadingSpinComponent])
class ContractInfoPaneComponent implements OnInit {
  final ContractsService _service;

  @Input()
  String contractId;

  ContractGeneralModel model;

  ContractInfoPaneComponent(this._service);

  @override
  ngOnInit() async {
    if (contractId == null) return;

    model = await _service.general.getContract(contractId);
  }

  contractChanged(String contractId) async {
    if (contractId == null) return;

    model = await _service.general.getContract(contractId);
  }
}
