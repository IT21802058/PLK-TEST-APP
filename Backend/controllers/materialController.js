import Material from '../models/materialModel.js';

// Create a new material
export const createMaterial = async (req, res) => {
    try {
        const { Material_ID, Material_Code, Material_Description, Material_Quantity } = req.body;

        const newMaterial = new Material({
            Material_ID,
            Material_Code,
            Material_Description,
            Material_Quantity,
        });

        const savedMaterial = await newMaterial.save();
        res.status(201).json(savedMaterial);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Fetch all materials
export const getAllMaterials = async (req, res) => {
    try {
        const materials = await Material.find({});
        res.status(200).json(materials);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Read material by ID
export const getMaterialById = async (req, res) => {
    try {
        const material = await Material.findById(req.params.id);
        if (!material) return res.status(404).json({ message: "Material not found" });
        
        res.status(200).json(material);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update material quantity
export const updateMaterialQuantity = async (req, res) => {
    try {
        const { Material_Quantity } = req.body;

        const updatedMaterial = await Material.findByIdAndUpdate(
            req.params.id,
            { Material_Quantity },
            { new: true } // returns the updated document
        );

        if (!updatedMaterial) return res.status(404).json({ message: "Material not found" });

        res.status(200).json(updatedMaterial);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Delete material by ID
export const deleteMaterial = async (req, res) => {
    try {
        const material = await Material.findByIdAndDelete(req.params.id);

        if (!material) return res.status(404).json({ message: "Material not found" });

        res.status(200).json({ message: "Material deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};