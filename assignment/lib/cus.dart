import 'package:flutter/material.dart';

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _creditAmountController = TextEditingController();
  String? _selectedReason;

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
      return 'Enter a valid amount greater than zero';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Customer Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Section(title: 'Customer details', child: CustomTextField(hintText: 'Customer name')),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: CustomTextField(hintText: 'Credit note', labelText: 'NEW')),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Date',
                        controller: _dateController,
                        readOnly: true,
                        suffixIcon: Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Section(title: 'Sales in-charge', child: CustomDropdown(hintText: 'Select Sales incharge')),
                SizedBox(height: 16),
                Section(
                  title: 'Reason',
                  child: Column(
                    children: [
                      ReasonDropdown(
                        onReasonSelected: (String? reason) {
                          setState(() {
                            _selectedReason = reason;
                            _creditAmountController.text = reason ?? '';
                          });
                        },
                      ),
                      SizedBox(height: 16),
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
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
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

// Section Widget
class Section extends StatelessWidget {
  final String title;
  final Widget child;

  const Section({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        child,
      ],
    );
  }
}

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.keyboardType,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatelessWidget {
  final String hintText;
  const CustomDropdown({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      hint: Text(hintText),
      items: ['Person1', 'Person2', 'Person3']
          .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
      onChanged: (value) {},
    );
  }
}

// Reason Dropdown Widget
class ReasonDropdown extends StatelessWidget {
  final Function(String?) onReasonSelected;
  ReasonDropdown({required this.onReasonSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      hint: Text('Select Reason'),
      items: ['Pending', 'Approved', 'Rejected', 'New']
          .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
      onChanged: (value) => onReasonSelected(value as String?),
    );
  }
}
