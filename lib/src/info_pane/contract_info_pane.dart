import 'package:angular2/core.dart';

import 'package:contracts/contract_general_model.dart';
import 'package:contracts/contracts_service.dart';

@Component(
  selector: 'contract-info-pane',
  providers: const [ContractsService],
  templateUrl: 'contract_info_pane.html')
class ContractInfoPaneComponent implements OnInit {
  final ContractsService _service;

  @Input()
  String contractId = '';

  ContractGeneralModel model = new ContractGeneralModel();

  ContractInfoPaneComponent(this._service);

  @override
  ngOnInit() async {
    model = await _service.general.getContract(contractId);
  }
}
