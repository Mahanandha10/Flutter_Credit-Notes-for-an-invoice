import 'package:flutter/material.dart';
import 'api_service.dart';

class CustomerForm extends StatefulWidget {
  @override
  CustomerFormState createState() => CustomerFormState();
  
}

class CustomerFormState extends State<CustomerForm> {
  String? _selectedItem; 
  String? _selectedReason;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _creditAmountController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  String? _validateCreditAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Credit Note Amount';
    }
    final num? amount = num.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

 void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final formData = {
      "name": _nameController.text,
      "credit_note": _newController.text,
      "date": _dateController.text,
      "sales_incharge": _selectedItem ?? "Person1",
      "reason": _selectedReason ?? "Aproved",
      "credit_amount": double.tryParse(_creditAmountController.text) ?? 0.0,
    };
    await ApiService().submitCustomerData(formData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form submitted successfully!')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(title: const Text('Customer Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Section(
                  title: 'Customer details',
                  child: Column(
                    children: [
                      CustomTextField(hintText: 'Customer name',
                      controller: _nameController,
                      ),
                      
                     const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'NEW',
                              controller: _newController,
                              readOnly: false,
                              labelText:"credit note",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              hintText: 'Date',
                              controller: _dateController,
                              readOnly: true,
                              suffixIcon: const Icon(Icons.calendar_month_outlined),
                              onTap: () => _selectDate(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Section(
                  title: 'Sales in-charge',
                  child: CustomDropdown(hintText: 'Sales incharge',
                 // controller: _selectedItem,
                  ),
                ),
                const SizedBox(height: 16),
                Section(
                  title: 'Reason',
                  
                  child: Column(
                    children: [
                      ReasonDropdown(),
                      
                     const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Reason for credit note',
                        hintText: 'Credit note amount',
                        controller: _creditAmountController,
                        keyboardType: TextInputType.number,
                        validator: _validateCreditAmount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Section Widget
class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final String? labelText;

  const Section({
    Key? key,
    required this.title,
    this.labelText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              labelText!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool readOnly;
  final String? labelText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.labelText,
    this.floatingLabelBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatefulWidget {
  final String hintText;

  CustomDropdown({Key? key, required this.hintText}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;
  final List<String> _items = ['Person1', 'Person2', 'Person3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedItem,
          hint: Text(widget.hintText, style: TextStyle(color: Colors.grey[700])),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue;
            });
          },
          items: _items.map((String value) {
            return DropdownMenuItem(
              
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ReasonDropdown extends StatefulWidget {
  @override
  _ReasonDropdownState createState() => _ReasonDropdownState();
}

class _ReasonDropdownState extends State<ReasonDropdown> {
  String? _selectedReason;
  final List<String> _reasons = [
    'New',
    'Pending',
    'Approved',
    'Rejected'
    
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedReason,
          hint: Text('Reason for credit note', style: TextStyle(color: Colors.grey[700])),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          onChanged: (String? newValue) {
            setState(() {
              _selectedReason = newValue;
            });
          },
          items: _reasons.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
