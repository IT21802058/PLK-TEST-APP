import mongoose from 'mongoose';

const materialSchema = mongoose.Schema({
    Material_ID: {
        type: String, 
        required: true
    },
    Material_Code: {
        type: String, 
        required: true,
        unique : true
    },
    Material_Description: {
        type: String, 
        required: true,
        unique : true
    },
    Material_Quantity: {
        type: String, 
        required: true,
        unique : true
    },
}, {
    timestamps: true
});

const Material = mongoose.model('Material', materialSchema);

export default Material;